
# Creates all the required services
resource "aws_ecs_service" "services" {
 count = contains(var.environments, "production") ? length(var.app_names) : 0
 name = join("-", ["prod", var.app_names[count.index], "service"])
 cluster = aws_ecs_cluster.production[0].id
 task_definition = join(":", [aws_ecs_task_definition.tasks[count.index].family, max(aws_ecs_task_definition.tasks[count.index].revision, data.aws_ecs_task_definition.tasks[count.index].revision)])
 enable_execute_command = true

 launch_type = "FARGATE"
 desired_count = 1
 // deployment_maximum_percent         = 100
 deployment_minimum_healthy_percent = 100

 load_balancer {
  target_group_arn = aws_lb_target_group.ips[count.index].arn
  container_name   = join("-", ["prod", var.app_names[count.index], "container"])
  container_port   = 8080
 }

 network_configuration {
  subnets = aws_subnet.private_subnet[*].id
  security_groups = [aws_security_group.instances[0].id]
  assign_public_ip = false
 }

 ordered_placement_strategy {
  type = "binpack"
  field = "cpu"
 }
 
 deployment_circuit_breaker {
  enable = true
  rollback = true
 }

 placement_constraints {
  type       = "memberOf"
  expression = join("", ["attribute:ecs.availability-zone in [", join(", ", var.availability_zones), "]"])
 }

 tags = {
  "Name" = join("-", ["prod", var.app_names[count.index], "service"])
  "Environemt" = "production"
 }
}