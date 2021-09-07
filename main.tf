# Creates the certificate
resource "aws_acm_certificate" "cert" {
 count = length(var.domains)
 domain_name       = var.domains[count.index]
 validation_method = "DNS"
 subject_alternative_names = [join(".", ["*", var.domains[count.index]])]

 tags = {
  Name = join("-", [var.region, var.domains[count.index], "certificate"])
  Environment = "all"
 }

 lifecycle {
  create_before_destroy = true
 }
}

data "aws_availability_zones" "available" {
 state = "available"
}

# Create cloudwatch logs group
resource "aws_cloudwatch_log_group" "ecs_tasks" {
 count = length(var.apps)
 name = "/ecs/${var.apps[count.index].name}-logs"

 retention_in_days = 90

 tags = {
  Name = "/ecs/${var.apps[count.index].name}-logs"
 }
}

module "develop" {
 source = "./modules/develop"
 region = var.region
 availability_zones = data.aws_availability_zones.available.names
 environments = var.environments
 platform_name = var.platform_name
 apps = var.apps
 vpc_cidr = var.vpc_cidr
 subnets_newbits = var.subnets_newbits
 domains = var.domains
 certificates_arn = aws_acm_certificate.cert[*].arn
 task_port = var.task_port
 task_execution_role_arn = var.task_execution_role_arn
 task_role_arn = var.task_role_arn
 iam_instance_role_name = var.iam_instance_role_name
 cloudwatch_groups = aws_cloudwatch_log_group.ecs_tasks[*].name
}

module "latest" {
 source = "./modules/latest"
 region = var.region
 availability_zones = data.aws_availability_zones.available.names
 environments = var.environments
 platform_name = var.platform_name
 apps = var.apps
 domains = var.domains
 vpc_id = module.develop.vpc_id
 alb_listener_https_default_arn = module.develop.alb_listener_https_default_arn
 ecs_cluster_id = module.develop.ecs_cluster_id
 ecr_repositories_urls = module.develop.ecr_repositories_urls
 private_subnets_ids = module.develop.private_subnets_ids
 task_port = var.task_port
 task_execution_role_arn = var.task_execution_role_arn
 task_role_arn = var.task_role_arn
 instances_security_group_id = module.develop.instances_security_group_id
 cloudwatch_groups = aws_cloudwatch_log_group.ecs_tasks[*].name
}

module "production" {
 source = "./modules/production"
 region = var.region
 availability_zones = data.aws_availability_zones.available.names
 environments = var.environments
 platform_name = var.platform_name
 apps = var.apps
 vpc_cidr = var.vpc_cidr
 subnets_newbits = var.subnets_newbits
 domains = var.domains
 certificates_arn = aws_acm_certificate.cert[*].arn
 task_port = var.task_port
 task_execution_role_arn = var.task_execution_role_arn
 task_role_arn = var.task_role_arn
 cloudwatch_groups = aws_cloudwatch_log_group.ecs_tasks[*].name
}