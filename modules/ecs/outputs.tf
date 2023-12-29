output "load_balancer_security_group_id" {
  value = aws_security_group.load_balancer_security_group.id
}

output "service_security_group_id" {
  value = aws_security_group.service_security_group.id
}

output "default_subnet_a_id" {
  value = aws_default_subnet.default_subnet_a.id
}

output "default_subnet_b_id" {
  value = aws_default_subnet.default_subnet_b.id
}

output "default_subnet_c_id" {
  value = aws_default_subnet.default_subnet_c.id
}

output "default_vpc_id" {
  value = aws_default_vpc.default_vpc.id
}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "cluster_id" {
  value = aws_ecs_cluster.url_shortener_app_cluster.id
}

output "cluster_name" {
  value = aws_ecs_cluster.url_shortener_app_cluster.name
}