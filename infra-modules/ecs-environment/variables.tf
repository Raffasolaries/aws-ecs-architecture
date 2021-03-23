variable "module" {
  description = "The terraform module used to deploy"
  type        = string
}

variable "profile" {
  description = "AWS profile"
  type        = string
}

variable "region" {
  description = "aws region to deploy to"
  type        = string
}

variable "platform_name" {
  description = "The name of the platform"
  type = string
}

variable "platform_name_develop" {
  description = "The name of the platform + env"
  type = string
}

variable "platform_name_latest" {
  description = "The name of the platform + env"
  type = string
}

variable "platform_name_production" {
  description = "The name of the platform + env"
  type = string
}

variable "app_port" {
  description = "Application port"
  type = number
}

variable "app_image" {
  type = string 
  description = "Container image to be used for application in task definition file"
}

variable "availability_zones" {
  type  = list(string)
  description = "List of availability zones for the selected region"
}

variable "app_count" {
  type = string 
  description = "The number of instances of the task definition to place and keep running."
}

variable "vpc_id" {
  type = string 
  description = "The id for the VPC where the ECS container instance should be deployed"
}

variable "cluster_id" {
  type = string 
  description = "Cluster ID"
}

variable "ecs_service_security_group_id" {
  type = string 
  description = "The ID of the security group for the ECS tasks"
}

variable "private_subnet_ids" {
  type = list(string)
  description = "IDs for private subnets"
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

# variable "main_pvt_route_table_id" {
#   type        = string
#   description = "Main route table id"
# }