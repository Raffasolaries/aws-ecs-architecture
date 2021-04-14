variable "name" {
  type        = string
  description = "The name of the application and the family"
}

variable "name_develop" {
  type        = string
  description = "The name of the application plus - the Environment"
}

variable "name_latest" {
  type        = string
  description = "The name of the application plus - the Environment"
}

variable "name_production" {
  type        = string
  description = "The name of the application plus - the Environment"
}

variable "app_image" {
  type = string 
  description = "Container image to be used for application in task definition file"
}

variable "fargate_cpu" {
  type = number
  description = "Fargate cpu allocation"
}

variable "fargate_memory" {
  type = number
  description = "Fargate memory allocation"
}

variable "app_port" {
  type = number
  description = "Application port"
}

variable "private_subnet_ids" {
  type = list(string)
  description = "IDs for private subnets"
}

variable "vpc_id" {
  type = string 
  description = "The id for the VPC where the ECS container instance should be deployed"
}

variable "cluster_id" {
  type = string 
  description = "Cluster ID"
}

variable "app_count" {
  type = string 
  description = "The number of instances of the task definition to place and keep running."
}

variable "aws_security_group_ecs_tasks_id" {
  type = string 
  description = "The ID of the security group for the ECS tasks"
}

variable "host_header_develop" {
  type = string 
  description = "The host which request the application target"
}

variable "host_header_latest" {
  type = string 
  description = "The host which request the application target"
}


variable "host_header_production" {
  type = string 
  description = "The host which request the application target"
}

variable "listener_arn" {
 type = string
 description = "Corporate Load Balancer ARN"
}

variable "task_definition_role_arn" {
 type = string
 description = "Task definition role ARN"
}

variable "load_balancer_name" {
 type = string
 description = "Load Balancer Name"
}

variable "load_balancer_id" {
 type = string
 description = "Load Balancer ARN"
}