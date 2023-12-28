terraform {
  required_version = "~> 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # backend "s3" {
  #   bucket         = "spg-tf-state-bucket"
  #   key            = "url-shortener-tf/terraform.tfstate"
  #   region         = "us-east-2"
  #   dynamodb_table = "spg-tf-state"
  #   encrypt        = true
  # }
}

module "tfState" {
  source      = "./modules/tfState"
  bucket_name = local.bucket_name
  table_name  = local.table_name
}

module "database" {
  source = "./modules/db"

  dynamo_table_name       = local.dynamo_table_name
  dynamo_table_key_attr   = local.dynamo_table_key_attr
  dynamo_table_index_attr = local.dynamo_table_index_attr
}

module "ecrRepo" {
  source = "./modules/ecr"

  url_shortener_backend_repo_name  = local.url_shortener_backend_repo_name
  url_shortener_frontend_repo_name = local.url_shortener_frontend_repo_name
}

module "ecsCluster" {
  source = "./modules/ecs"

  url_shortener_app_cluster_name = local.url_shortener_app_cluster_name
  availability_zones             = local.availability_zones
  ecs_task_execution_role_name   = local.ecs_task_execution_role_name
}

module "ecsBackend" {
  source = "./modules/ecs-backend"

  aws_backend_region = local.aws_region

  backend_ecr_repo_url = module.ecrRepo.backend_repository_url

  cluster_id                      = module.ecsCluster.cluster_id
  default_vpc_id                  = module.ecsCluster.default_vpc_id
  default_subnet_a_id             = module.ecsCluster.default_subnet_a_id
  default_subnet_b_id             = module.ecsCluster.default_subnet_b_id
  default_subnet_c_id             = module.ecsCluster.default_subnet_c_id
  ecs_task_execution_role_arn     = module.ecsCluster.ecs_task_execution_role_arn
  load_balancer_security_group_id = module.ecsCluster.load_balancer_security_group_id
  service_security_group_id       = module.ecsCluster.service_security_group_id

  backend_load_balancer_name        = local.backend_load_balancer_name
  backend_app_task_family           = local.backend_app_task_family
  backend_app_task_name             = local.backend_app_task_name
  backend_app_service_name          = local.backend_app_service_name
  backend_target_group_name         = local.backend_target_group_name
  backend_container_port            = local.backend_container_port
  backend_cloudwatch_log_group_name = local.backend_cloudwatch_log_group_name
  backend_cloudwatch_stream_prefix  = local.backend_cloudwatch_stream_prefix

  backend_service_instances = local.backend_service_instances
  backend_instance_cpu      = local.backend_instance_cpu
  backend_instance_memory   = local.backend_instance_memory
}

module "ecsFrontend" {
  source = "./modules/ecs-frontend"

  aws_frontend_region = local.aws_region

  frontend_ecr_repo_url = module.ecrRepo.frontend_repository_url

  cluster_id                      = module.ecsCluster.cluster_id
  default_vpc_id                  = module.ecsCluster.default_vpc_id
  default_subnet_a_id             = module.ecsCluster.default_subnet_a_id
  default_subnet_b_id             = module.ecsCluster.default_subnet_b_id
  default_subnet_c_id             = module.ecsCluster.default_subnet_c_id
  ecs_task_execution_role_arn     = module.ecsCluster.ecs_task_execution_role_arn
  load_balancer_security_group_id = module.ecsCluster.load_balancer_security_group_id
  service_security_group_id       = module.ecsCluster.service_security_group_id

  frontend_load_balancer_name        = local.frontend_load_balancer_name
  frontend_app_task_family           = local.frontend_app_task_family
  frontend_app_task_name             = local.frontend_app_task_name
  frontend_app_service_name          = local.frontend_app_service_name
  frontend_target_group_name         = local.frontend_target_group_name
  frontend_container_port            = local.frontend_container_port
  frontend_cloudwatch_log_group_name = local.frontend_cloudwatch_log_group_name
  frontend_cloudwatch_stream_prefix  = local.frontend_cloudwatch_stream_prefix

  frontend_service_instances = local.frontend_service_instances
  frontend_instance_cpu      = local.frontend_instance_cpu
  frontend_instance_memory   = local.frontend_instance_memory
}