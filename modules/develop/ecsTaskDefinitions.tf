resource "aws_ecs_task_definition" "tasks" {
 count = contains(var.environments, "develop") ? length(var.app_names) : 0
 family = join("-", ["develop", var.app_names[count.index], "task"])
 container_definitions = jsonencode([
  {
   name      = join("-", ["develop", var.app_names[count.index], "task"])
   image     = aws_ecr_repository.staging[count.index].name
   cpu       = 256
   memory    = 512
   execution_role_arn = var.task_execution_role_arn
   essential = true
   network_mode = "awsvpc"
   requires_compatibilities = ["EC2"]
   logConfiguration = {
    logDriver = "awslogs"
    options = {
     awslogs-group = "/ecs/tantosvago30-task"
     awslogs-region = "eu-west-3"
     awslogs-stream-prefix = "ecs"
    }
   }
   ephemeral_storage = {
    size_in_gib = 5
   }
   portMappings = [
    {
     containerPort = var.task_port
    }
   ]
  }
 ])

 placement_constraints {
  type       = "memberOf"
  expression = join("", ["attribute:ecs.availability-zone in [", join(", ", var.availability_zones), "]"])
 } 
}