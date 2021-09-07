output "staging_ecr_repositories_urls" {
 description = "ECR Staging repositories names"
 value = module.develop.ecr_repositories_urls
}

output "production_ecr_repositories_urls" {
 description = "ECR Production repositories names"
 value = module.production.ecr_repositories_urls
}

output "staging_alb_name" {
 description = "Staging ALB Name"
 value = module.develop.alb_name
}

output "production_alb_name" {
 description = "Production ALB Name"
 value = module.production.alb_name
}