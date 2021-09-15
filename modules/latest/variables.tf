variable "region" {
 description = "AWS deployment region"
 type = string
 default = "eu-south-1"
}

variable "environments" {
 type = list
 description = "referral environments"
}

variable "availability_zones" {
 description = "Selected region Availability Zones"
 type = list
}

variable "platform_name" {
 description = "Platform name"
 type = string
}

variable "vpc_id" {
 description = "Staging VPC ID"
 type = string
}

variable "ecs_cluster_id" {
 description = "Staging ECS Cluster ID"
 type = string
}

variable "apps" {
 type = list(object({
  name = string
  domain = string
 }))
 description = "Application names and their domain associations"
}

variable "domains" {
 type = list
 description = "Domain names list (without subdomain)"
}

variable "task_port" {
 type = number
 description = "Application Container exposed port"
}

variable "task_execution_role_arn" {
 type = string
 description = "ECS Tasks Execution role arn"
}

variable "task_role_arn" {
 type = string
 description = "ECS Tasks Execution role arn"
}

variable "alb_listener_https_default_arn" {
 description = "Staging ALB HTTPS default listener ARN"
 type = string
}

variable "private_subnets_ids" {
 description = "Staging Private Subnets IDs"
 type = list
}

variable "instances_security_group_id" {
 description = "Staging Instances Security Group ID"
 type = string
}

variable "iam_instance_role_name" {
 type = string
 description = "IAM instance role name"
}

variable "ecr_repositories_urls" {
 description = "Staging ECR Repositories URLs"
 type = list
}

variable "cloudwatch_groups" {
 type = list
 description = "CloudWatch Logs Group for ECS Task containers"
}
