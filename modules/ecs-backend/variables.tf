variable "aws_backend_region" {
  description = "default region for the backend app"
  type        = string
}

variable "backend_ecr_repo_url" {
  description = "ECR backend Repo URL"
  type        = string
}

variable "backend_app_task_family" {
  description = "ECS Backend Task Family"
  type        = string
}

variable "backend_container_port" {
  description = "Backend Container Port"
  type        = number
}

variable "backend_app_task_name" {
  description = "ECS Task Name"
  type        = string
}

variable "backend_target_group_name" {
  description = "ALB Backend Target Group Name"
  type        = string
}

variable "backend_app_service_name" {
  description = "ECS Backend Service Name"
  type        = string
}

variable "backend_load_balancer_name" {
  description = "Backend load balancer name"
  type        = string
}

variable "load_balancer_security_group_id" {
  description = "ECS Load balancer security group id"
  type        = string
}

variable "service_security_group_id" {
  description = "Service security group id"
  type        = string
}

variable "default_subnet_a_id" {
  description = "subnet a"
  type        = string
}

variable "default_subnet_b_id" {
  description = "subnet b"
  type        = string
}

variable "default_subnet_c_id" {
  description = "subnet c"
  type        = string
}

variable "default_vpc_id" {
  description = "Default VPC id"
  type        = string
}

variable "ecs_task_execution_role_arn" {
  description = "Execution role arn"
  type        = string
}

variable "cluster_id" {
  description = "ECS Cluster id"
  type        = string
}

variable "backend_cloudwatch_log_group_name" {
  description = "Cloudwatch log group name for the backend app"
  type        = string
}

variable "backend_cloudwatch_stream_prefix" {
  description = "Cloudwatch log stream prefix for the backend app"
  type        = string
}

variable "backend_service_instances" {
  description = "Horizontal scaling: quantity of instances of the backend service"
  type        = number
}

variable "backend_instance_cpu" {
  description = "Vertical scaling: cpu capacity of the backend service"
  type        = number
}

variable "backend_instance_memory" {
  description = "Vertical scaling: memory capacity of the backend service"
  type        = number
}

variable "cluster_name" {
  description = "Ecs cluster name"
  type        = string
}