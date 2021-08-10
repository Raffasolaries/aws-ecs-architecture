output "ecr_repositories" {
 description = "ECR repositories names"
 value = [for repository in aws_ecr_repository.staging : repository.name]
}