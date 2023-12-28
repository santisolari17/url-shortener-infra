# Terraform AWS Infrastructure for url-shortener-app

This Terraform project is designed to provision infrastructure on AWS for the "url-shortener-app." The project is organized into modules to manage different aspects of the infrastructure.

## Modules

### 1. Database module (db)

The `db` module is responsible for creating the databases needed for the url-shortener app

### 2. Terraform State module (tfState)

The `tfState` module is responsible for creating the S3 bucket and the terraform apply locks dynamo db table needed for remote state managing.

### 3. Elastic Container Registry module (ECR)

the `ecr` module is responsible for creating the Docker container registries that will store the backend and frontend apps container images.

### 4. Elastic Container Service (ECS)

The `ECS` module is responsible for creating the ecs cluister, subnets and other networking components required for the url-shortener-app.

### 5. ECS Backend

the `ecs-backend` module is responsible for creating the specific networking components, like the load balancer, listener and the service definition for the backend app.

### 6. ECS Frontend

the `ecs-frontend` module is responsible for creating the specific networking components, like the load balancer, listener and the service definition for the frontend app.

## Capacity and Performance

### 1. Horizontal and Vertical scaling:

The horizontal scaling properties can be found in the `locals.tf` file under the `Capacity and Performance Management` section:

```hcl
  // Horizontal Scaling
  backend_service_instances  = // The number of instances for the backend service
  frontend_service_instances = // The number of instances for the frontend service

  // Vertical scaling
  backend_instance_cpu     = // The CPU capacity of each backend instance
  backend_instance_memory  = // The memory capacity of each backend instance
  frontend_instance_cpu    = // The CPU capacity of each frontend instance
  frontend_instance_memory = // The memory capacity of each frontend instance
```