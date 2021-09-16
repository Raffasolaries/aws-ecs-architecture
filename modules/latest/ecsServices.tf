# Creates all the required services
resource "aws_ecs_service" "services" {
 count = contains(var.environments, "latest") ? length(var.apps) : 0
 name = join("-", ["latest", var.apps[count.index].name, "service"])
 cluster = var.ecs_cluster_id
 task_definition = join(":", [aws_ecs_task_definition.tasks[count.index].family, max(aws_ecs_task_definition.tasks[count.index].revision, data.aws_ecs_task_definition.tasks[count.index].revision)])
 enable_execute_command = true

 // launch_type = "FARGATE"
 desired_count = 1
 deployment_maximum_percent         = 100
 deployment_minimum_healthy_percent = 0

 force_new_deployment = false

 load_balancer {
  target_group_arn = aws_lb_target_group.instances[count.index].arn
  container_name   = join("-", ["latest", var.apps[count.index].name, "container"])
  container_port   = var.task_port
 }

 capacity_provider_strategy {
  capacity_provider = "FARGATE_SPOT"
  base = 1
  weight = 1
 }

 network_configuration {
  subnets = var.private_subnets_ids
  security_groups = [var.instances_security_group_id]
  assign_public_ip = false
 }
 
 deployment_circuit_breaker {
  enable = false
  rollback = false
 }

 tags = {
  "Name" = join("-", ["latest", var.apps[count.index].name, "service"])
  "Environemt" = "latest"
 }
}