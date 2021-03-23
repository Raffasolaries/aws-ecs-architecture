resource "aws_ecs_service" "develop" {
  name            = "${var.name_develop}-service"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.develop.family
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [var.aws_security_group_ecs_tasks_id]
    subnets = var.private_subnet_ids
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.develop.arn
    container_name   = "${var.name_develop}-container"
    container_port   = var.app_port
  }

  depends_on = [
    aws_ecs_task_definition.develop
  ]

  tags = {
    Name = "${var.name_develop}-service"
  }
}

resource "aws_ecs_service" "latest" {
  name            = "${var.name_latest}-service"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.latest.family
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [var.aws_security_group_ecs_tasks_id]
    subnets = var.private_subnet_ids
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.latest.arn
    container_name   = "${var.name_latest}-container"
    container_port   = var.app_port
  }

  tags = {
    Name = "${var.name_latest}-service"
  }

  depends_on = [
    aws_ecs_task_definition.latest
  ]
}

resource "aws_ecs_service" "production" {
  name            = "${var.name_production}-service"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.production.family
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [var.aws_security_group_ecs_tasks_id]
    subnets = var.private_subnet_ids
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.production.arn
    container_name   = "${var.name_production}-container"
    container_port   = var.app_port
  }

  tags = {
    Name = "${var.name_production}-service"
  }

  depends_on = [
    aws_ecs_task_definition.production,
  ]
}