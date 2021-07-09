module "develop" {
 source = "./modules/develop"
 region = var.region
 environment = var.environment
 platform_name = var.platform_name
 app_name = var.app_name
 vpc_cidr = var.vpc_cidr
 subnets_newbits = var.subnets_newbits
}