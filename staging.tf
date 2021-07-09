module "develop" {
 source = "./modules/develop"
 environment = var.environment
 platform_name = var.platform_name
 app_name = var.app_name
 vpc_cidr = var.vpc_cidr
 public_subnets_cidr = var.public_subnets_cidr
 private_subnets_cidr = var.private_subnets_cidr
}