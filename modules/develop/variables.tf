variable "region" {
 description = "AWS deployment region"
 type = string
 default = "eu-south-1"
}

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

variable "subnets_newbits" {
 type = number
 description = "the difference between subnet mask and network mask"
}

variable "task_port" {
 type = number
 description = "Application exposed port to Load Balancer"
}