variable "region" {
 description = "AWS deployment region"
 type = string
 default = "eu-south-1"
}

variable "availability_zones" {
 description = "Selected region Availability Zones"
 type = list
}

variable "environments" {
 type = list
 description = "referral environments"
}

variable "platform_name" {
 description = "Platform name"
 type = string
}

variable "app_names" {
 type = list
 description = "Application name"
}

variable "vpc_cidr" {
 type = string
 description = "CIDR VPC block"
}

variable "subnets_newbits" {
 type = number
 description = "the difference between subnet mask and network mask"
}

variable "domain" {
 type = string
 description = "Base domain of the app (without subdomain)"
}

variable "certificate_arn" {
 type = string
 description = "ARN of the main application domain certificate"
}

variable "task_port" {
 type = number
 description = "Application exposed port to Load Balancer"
}

variable "task_execution_role_arn" {
 type = string
 description = "ECS Tasks Execution role arn"
}

variable "task_role_arn" {
 type = string
 description = "ECS Tasks Execution role arn"
}

variable "iam_instance_role_name" {
 type = string
 description = "IAM instance role name"
}

variable "cloudwatch_groups" {
 type = list
 description = "CloudWatch Logs Group for ECS Task containers"
}