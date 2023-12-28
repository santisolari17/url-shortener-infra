variable "aws_frontend_region" {
  description = "default region for the frontend app"
  type        = string
}

variable "frontend_ecr_repo_url" {
  description = "ECR frontend Repo URL"
  type        = string
}

variable "frontend_app_task_family" {
  description = "ECS frontend Task Family"
  type        = string
}

variable "frontend_container_port" {
  description = "frontend Container Port"
  type        = number
}

variable "frontend_app_task_name" {
  description = "ECS Task Name"
  type        = string
}

variable "frontend_target_group_name" {
  description = "ALB frontend Target Group Name"
  type        = string
}

variable "frontend_app_service_name" {
  description = "ECS frontend Service Name"
  type        = string
}

variable "frontend_load_balancer_name" {
  description = "frontend load balancer name"
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

variable "frontend_cloudwatch_log_group_name" {
  description = "Cloudwatch log group name for the frontend app"
  type        = string
}

variable "frontend_cloudwatch_stream_prefix" {
  description = "Cloudwatch log stream prefix for the frontend app"
  type        = string
}

variable "frontend_service_instances" {
  description = "Horizontal scaling: quantity of instances of the frontend service"
  type        = number
}

variable "frontend_instance_cpu" {
  description = "Vertical scaling: cpu capacity of the frontend service"
  type        = number
}

variable "frontend_instance_memory" {
  description = "Vertical scaling: memory capacity of the frontend service"
  type        = number
}