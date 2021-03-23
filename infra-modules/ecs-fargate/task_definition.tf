resource "aws_ecs_task_definition" "main" {
  family             = "${var.name}-${var.environment}-task"
  task_role_arn = var.task_definition_role_arn
  execution_role_arn = var.task_definition_role_arn
  network_mode       = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu    = var.fargate_cpu
  memory = var.fargate_memory
  container_definitions = jsonencode([
    {
      name : "${var.name}-${var.environment}-container",
      image : var.app_image,
      cpu : var.fargate_cpu,
      memory : var.fargate_memory,
      networkMode : "awsvpc",
      portMappings : [
        {
          containerPort : var.app_port
          protocol : "tcp"
        }
      ]
    }
  ])
}