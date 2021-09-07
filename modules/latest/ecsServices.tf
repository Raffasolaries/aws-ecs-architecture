# Creates all the required services
resource "aws_ecs_service" "services" {
 count = contains(var.environments, "latest") ? length(var.apps) : 0
 name = join("-", ["latest", var.apps[count.index].name, "service"])
 cluster = var.ecs_cluster_id
 task_definition = join(":", [aws_ecs_task_definition.tasks[count.index].family, max(aws_ecs_task_definition.tasks[count.index].revision, data.aws_ecs_task_definition.tasks[count.index].revision)])
 enable_execute_command = true

 launch_type = "EC2"
 desired_count = 1
 deployment_maximum_percent         = 100
 deployment_minimum_healthy_percent = 0

 load_balancer {
  target_group_arn = aws_lb_target_group.instances[count.index].arn
  container_name   = join("-", ["latest", var.apps[count.index].name, "container"])
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

 tags = {
  "Name" = join("-", ["latest", var.apps[count.index].name, "service"])
  "Environemt" = "latest"
 }
}