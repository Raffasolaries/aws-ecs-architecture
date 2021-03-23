resource "aws_ecs_task_definition" "develop" {
  family             = "${var.name_develop}-task"
  task_role_arn = var.task_definition_role_arn
  execution_role_arn = var.task_definition_role_arn
  network_mode       = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu    = var.fargate_cpu
  memory = var.fargate_memory
  container_definitions = jsonencode([
    {
      name : "${var.name_develop}-container",
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

resource "aws_ecs_task_definition" "latest" {
  family             = "${var.name_latest}-task"
  task_role_arn = var.task_definition_role_arn
  execution_role_arn = var.task_definition_role_arn
  network_mode       = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu    = var.fargate_cpu
  memory = var.fargate_memory
  container_definitions = jsonencode([
    {
      name : "${var.name_latest}-container",
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

resource "aws_ecs_task_definition" "production" {
  family             = "${var.name_production}-task"
  task_role_arn = var.task_definition_role_arn
  execution_role_arn = var.task_definition_role_arn
  network_mode       = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu    = var.fargate_cpu
  memory = var.fargate_memory
  container_definitions = jsonencode([
    {
      name : "${var.name_production}-container",
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