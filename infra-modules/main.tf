# ECS cluster
module ecs_cluster {
  source = "./ecs-cluster"
  name = "${var.platform_name}-${var.environment}-cluster"
  cluster_tag_name = "${var.platform_name}-${var.environment}-cluster"
}

# ECS task definition and service
module ecs_task_definition_and_service {
  # Task definition and NLB
  source = "./ecs-fargate"
  name = "${var.platform_name}-${var.environment}"
  app_image = var.app_image
  fargate_cpu                 = 1024
  fargate_memory              = 2048
  app_port = var.app_port
  vpc_id = module.vpc_for_ecs_fargate.vpc_id
  environment = var.environment
  # Service
  cluster_id = module.ecs_cluster.id 
  app_count = var.app_count
  aws_security_group_ecs_tasks_id = module.vpc_for_ecs_fargate.ecs_tasks_security_group_id
  private_subnet_ids = module.vpc_for_ecs_fargate.private_subnet_ids
}