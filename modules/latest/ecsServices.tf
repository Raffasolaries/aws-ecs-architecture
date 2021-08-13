# Creates all the required services
resource "aws_ecs_service" "services" {
 count = contains(var.environments, "latest") ? length(var.app_names) : 0
 name = join("-", ["latest", var.app_names[count.index], "service"])
 cluster = var.ecs_cluster_id
 task_definition = aws_ecs_task_definition.tasks[count.index].arn
 enable_execute_command = true

 launch_type = "EC2"
 desired_count = 1
 deployment_maximum_percent         = 100
 deployment_minimum_healthy_percent = 0

 load_balancer {
  target_group_arn = var.alb_target_groups_instances_arns[count.index]
  container_name   = join("-", ["latest", var.app_names[count.index], "container"])
  container_port   = 8080
 }

 network_configuration {
  subnets = var.private_subnets_ids[*]
  security_groups = [var.instances_security_group_id]
  assign_public_ip = false
 }

 ordered_placement_strategy {
  type = "binpack"
  field = "cpu"
 }
 
 deployment_circuit_breaker {
  enable = false
  rollback = false
 }

 placement_constraints {
  type       = "memberOf"
  expression = join("", ["attribute:ecs.availability-zone in [", join(", ", var.availability_zones), "]"])
 }
}