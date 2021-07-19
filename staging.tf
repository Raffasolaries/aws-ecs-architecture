module "develop" {
 source = "./modules/develop"
 region = var.region
 environments = var.environments
 platform_name = var.platform_name
 app_names = var.app_names
 vpc_cidr = var.vpc_cidr
 subnets_newbits = var.subnets_newbits
 domain = var.domain
 certificate_arn = aws_acm_certificate.cert.arn
 task_port = var.task_port
}