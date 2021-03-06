output "vpc_arn" {
 description = "Production VPC ARN"
 value = aws_vpc.vpc[0].arn
}

output "vpc_id" {
 description = "Production VPC ID"
 value = aws_vpc.vpc[0].id
}

output "private_subnet_ids" {
 description = "Private subnet ids"
 value = aws_subnet.private_subnet[*].id
}

output "service_security_group_id" {
 description = "Security Group allows communication from ECS service to Docker containers"
 value = aws_security_group.instances[0].id
} 

output "ecr_repositories_urls" {
 description = "ECR repositories URLs"
 value = [for repository in aws_ecr_repository.production : repository.repository_url]
}

output "ecs_cluster_id" {
 description = "Production ECS Cluster ID"
 value = aws_ecs_cluster.production[0].id
}

output "alb_name" {
 description = "Production ALB Name"
 value = aws_lb.alb[0].name
}

output "alb_listener_https_default_arn" {
 description = "Production ALB HTTPS default listerner ARN"
 value = aws_lb_listener.https_default[0].arn
}

output "private_subnets_ids" {
 description = "Private Subnets IDs"
 value = aws_subnet.private_subnet[*].id
}

output "instances_security_group_id" {
 description = "Instances Security Group"
 value = aws_security_group.instances[0].id
}