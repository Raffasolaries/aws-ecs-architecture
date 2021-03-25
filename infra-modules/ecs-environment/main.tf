# ECS task definition and service
module ecs_task_definition_and_service {
 # Task definition and NLB
 source = "./ecs-fargate"
 name = var.platform_name
 name_develop = var.platform_name_develop
 name_latest = var.platform_name_latest
 name_production = var.platform_name_production
 app_image = var.app_image
 fargate_cpu                 = 1024
 fargate_memory              = 2048
 app_port = var.app_port
 vpc_id = var.vpc_id

 # Service
 cluster_id = var.cluster_id
 app_count = var.app_count
 aws_security_group_ecs_tasks_id = var.ecs_service_security_group_id
 private_subnet_ids = var.private_subnet_ids
 host_header_develop = var.host_header_develop
 host_header_latest = var.host_header_latest
 host_header_production = var.host_header_production
 listener_arn = var.listener_arn
 task_definition_role_arn = module.alb_target_groups_rules.develop_arn
 // task_definition_role_arn = var.task_definition_role_arn

 # Load Balancer
 load_balancer_name = var.load_balancer_name
 load_balancer_id = var.load_balancer_id
 region = var.region
}

module alb_target_groups_rules {
 source = "./alb-target-groups-rules"
}