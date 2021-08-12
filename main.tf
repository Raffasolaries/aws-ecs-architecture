# Creates the certificate
resource "aws_acm_certificate" "cert" {
 domain_name       = var.domain
 validation_method = "DNS"
 subject_alternative_names = [join(".", ["*", var.domain])]

 tags = {
  Name = join("-", [var.region, var.domain, "certificate"])
  Environment = "all"
 }

 lifecycle {
  create_before_destroy = true
 }
}

data "aws_availability_zones" "available" {
 state = "available"
}

module "develop" {
 source = "./modules/develop"
 region = var.region
 availability_zones = data.aws_availability_zones.available.names
 environments = var.environments
 platform_name = var.platform_name
 app_names = var.app_names
 vpc_cidr = var.vpc_cidr
 subnets_newbits = var.subnets_newbits
 domain = var.domain
 certificate_arn = aws_acm_certificate.cert.arn
 task_port = var.task_port
 task_execution_role_arn = var.task_execution_role_arn
 task_role_arn = var.task_role_arn
}

module "latest" {
 source = "./modules/latest"
}