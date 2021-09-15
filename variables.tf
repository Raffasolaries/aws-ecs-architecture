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

variable "apps" {
 type = list(object({
  name = string
  domain = string
 }))
 description = "Application names and their domain associations"
}

variable "vpc_cidr" {
 type = string
 description = "CIDR VPC block"
}

variable "subnets_newbits" {
 type = number
 description = "the difference between subnet mask and network mask"
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

variable "iam_instance_role_name" {
 type = string
 description = "IAM instance role name"
}

variable "staging_num_instances" {
 type = number
 description = "Number of EC2 instances which will be created in the staging environment"
}