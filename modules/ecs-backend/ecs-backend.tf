resource "aws_alb" "application_load_balancer" {
  name               = var.backend_load_balancer_name
  load_balancer_type = "application"
  subnets = [
    "${var.default_subnet_a_id}",
    "${var.default_subnet_b_id}",
    "${var.default_subnet_c_id}"
  ]
  security_groups = ["${var.load_balancer_security_group_id}"]

  enable_http2                     = true
  enable_cross_zone_load_balancing = true
}

# No need to create, already provided
# resource "aws_route53_zone" "spg_hosted_zone" {
#   name          = "sbx6.blue.cl"
#   comment       = "url shortener app hosted zone"
#   force_destroy = true

#   tags = {
#     Name : "spg_hosted_zone"
#     Application : "url-shortener app"
#   }
# }

// domain name provided by Jean-Paul (sbx5.blue.cl) + added "back" subdomain
resource "aws_acm_certificate" "backend_certificate" {
  domain_name       = "back.sbx5.blue.cl"
  validation_method = "DNS"

  tags = {
    Name = "url-shortener-backend-certificate"
  }
}

resource "aws_route53_record" "backend_hosted_zone_record" {
  zone_id = "Z07503551JZ2YCLTT7R4O" // provided by Jean-Paul (sbx5.blue.cl)
  name    = aws_acm_certificate.backend_certificate.domain_name
  type    = "CNAME"
  ttl     = 300

  records = [aws_alb.application_load_balancer.dns_name]
}

# resource "aws_acm_certificate_validation" "backend_certificate_validation" {
#   certificate_arn         = aws_acm_certificate.backend_certificate.arn
#   validation_record_fqdns = [aws_route53_record.backend_hosted_zone_record.fqdn]
# }

resource "aws_lb_target_group" "backend_target_group" {
  name        = "${var.backend_target_group_name}-${substr(uuid(), 0, 3)}"
  port        = var.backend_container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.default_vpc_id

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [name]
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.application_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_target_group.arn
  }

}

resource "aws_lb_listener_rule" "listener_rule" {
  listener_arn = aws_lb_listener.listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/health"]
    }
  }
}

# resource "aws_lb_listener" "listener" {
#   load_balancer_arn = aws_alb.application_load_balancer.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = aws_acm_certificate.backend_certificate.arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.backend_target_group.arn
#   }
# }

resource "aws_cloudwatch_log_group" "backend_log_group" {
  name              = var.backend_cloudwatch_log_group_name
  retention_in_days = 1
  tags = {
    Application = "url shortener backend container logs"
  }
}

resource "aws_ecs_task_definition" "backend_app_task" {
  family                   = var.backend_app_task_family
  container_definitions    = <<DEFINITION
  [
    {
      "name": "${var.backend_app_task_name}",
      "image": "${var.backend_ecr_repo_url}:latest",
      "essential": true,
      "portMappings": [
        {
          "containerPort": ${var.backend_container_port},
          "hostPort": ${var.backend_container_port}
        }
      ],
      "memory": ${var.backend_instance_memory},
      "cpu": ${var.backend_instance_cpu},
      "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
              "awslogs-group": "${aws_cloudwatch_log_group.backend_log_group.name}",
              "awslogs-region": "${var.aws_backend_region}",
              "awslogs-stream-prefix": "${var.backend_cloudwatch_stream_prefix}"
          }
      }
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = var.backend_instance_memory
  cpu                      = var.backend_instance_cpu
  execution_role_arn       = var.ecs_task_execution_role_arn
}

resource "aws_ecs_service" "backend_app_service" {
  name            = var.backend_app_service_name
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.backend_app_task.arn
  launch_type     = "FARGATE"
  desired_count   = var.backend_service_instances

  load_balancer {
    target_group_arn = aws_lb_target_group.backend_target_group.arn
    container_name   = aws_ecs_task_definition.backend_app_task.family
    container_port   = var.backend_container_port
  }

  network_configuration {
    subnets          = ["${var.default_subnet_a_id}", "${var.default_subnet_b_id}", "${var.default_subnet_c_id}"]
    assign_public_ip = true
    security_groups  = ["${var.service_security_group_id}"]
  }
}

# Create an ECS Auto Scaling Policy
resource "aws_appautoscaling_target" "backend_ecs_autoscaling_target" {
  max_capacity       = 10
  min_capacity       = 3
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.backend_app_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}
resource "aws_appautoscaling_policy" "backend_scaling_policy" {
  name               = "backend_scaling_policy"
  service_namespace  = aws_appautoscaling_target.backend_ecs_autoscaling_target.service_namespace
  scalable_dimension = aws_appautoscaling_target.backend_ecs_autoscaling_target.scalable_dimension
  resource_id        = aws_appautoscaling_target.backend_ecs_autoscaling_target.resource_id
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 10.0
  }
}