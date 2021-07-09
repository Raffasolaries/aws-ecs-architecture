variable "environment" {
 type = string
 description = "referral environment"
}

variable "platform_name" {
 description = "Platform name"
 type = string
}

variable "app_name" {
 type = string
 description = "Application name"
}

variable "vpc_cidr" {
 type = string
 description = "CIDR VPC block"
}

variable "public_subnets_cidr" {
 type = list
 description = "cidr blocks for public subnets"
}

variable "private_subnets_cidr" {
 type = list
 description = "cidr blocks for private subnets"
}