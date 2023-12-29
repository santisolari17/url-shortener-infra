locals {
  bucket_name = "spg-tf-state-bucket"
  table_name  = "spg-tf-state"

  dynamo_table_name       = "shortUrls"
  dynamo_table_key_attr   = "urlId"
  dynamo_table_index_attr = "longUrl"

  # App events table
  dynamo_events_table_name       = "appEvents"
  dynamo_events_table_key_attr   = "eventId"
  dynamo_events_table_index_attr = "eventType"
  dynamo_events_table_range_attr = "lastVisited"

  url_shortener_backend_repo_name  = "url-shortener-backend-repo"
  url_shortener_frontend_repo_name = "url-shortener-frontend-repo"

  aws_region                     = "us-east-2"
  url_shortener_app_cluster_name = "url-shortener-app-cluster"
  availability_zones             = ["us-east-2a", "us-east-2b", "us-east-2c"]
  ecs_task_execution_role_name   = "url-shortener-app-task-execution-role"

  backend_load_balancer_name        = "url-shortener-app-alb"
  backend_app_task_family           = "backend-app-task"
  backend_app_task_name             = "backend-app-task"
  backend_app_service_name          = "url-shortener-backend-service"
  backend_target_group_name         = "backend-alb-tg"
  backend_cloudwatch_log_group_name = "logs-url-shortener-backend"
  backend_cloudwatch_stream_prefix  = "url-shortener-backend"
  backend_container_port            = 3000

  frontend_load_balancer_name        = "url-shortener-app-frontend-alb"
  frontend_app_task_family           = "frontend-app-task"
  frontend_app_task_name             = "frontend-app-task"
  frontend_app_service_name          = "url-shortener-frontend-service"
  frontend_target_group_name         = "frontend-alb-tg"
  frontend_cloudwatch_log_group_name = "logs-url-shortener-frontend"
  frontend_cloudwatch_stream_prefix  = "url-shortener-frontend"
  frontend_container_port            = 80

  // Capacity and Performance Management
  // Horizontal Scaling
  backend_service_instances  = 3
  frontend_service_instances = 2
  // Vertical scaling
  backend_instance_cpu     = 2048
  backend_instance_memory  = 4096
  frontend_instance_cpu    = 512
  frontend_instance_memory = 1024
}