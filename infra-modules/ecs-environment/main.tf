# ECS task definition and service
module ecs_task_definition_and_service {
  # Task definition and NLB
  source = "./ecs-fargate"
  name = var.platform_name
  name_env = var.platform_name_env
  app_image = var.app_image
  fargate_cpu                 = 1024
  fargate_memory              = 2048
  app_port = var.app_port
  vpc_id = var.vpc_id
  environment = var.environment
  # Service
  cluster_id = var.cluster_id
  app_count = var.app_count
  aws_security_group_ecs_tasks_id = var.ecs_service_security_group_id
  private_subnet_ids = var.private_subnet_ids
  host_header = var.host_header
  listener_arn = var.listener_arn
  task_definition_role_arn = var.task_definition_role_arn
}