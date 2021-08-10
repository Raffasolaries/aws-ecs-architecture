variable "region" {
 description = "AWS deployment region"
 type = string
 default = "eu-south-1"
}

variable "profile" {
 description = "AWS IAM user credentials"
 type = string
}
// to use in staging modules
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

variable "service_role" {
 type = string
 description = "ECS Services role"
}