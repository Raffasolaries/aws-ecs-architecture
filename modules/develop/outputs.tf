output "vpc_arn" {
 description = "Staging VPC ARN"
 value = aws_vpc.vpc[0].arn
}

output "private_subnet_ids" {
 description = "Private subnet ids"
 value = aws_subnet.private_subnet[*].id
}

output "service_security_group_id" {
 description = "Security Group allows communication from ECS service to Docker containers"
 value = aws_security_group.service[0].id
} 

output "ecr_repositories" {
 description = "ECR repositories names"
 value = [for repository in aws_ecr_repository.staging : repository.name]
}