data "aws_ecs_task_definition" "tasks" {
 count = contains(var.environments, "production") ? length(var.app_names) : 0
 task_definition = aws_ecs_task_definition.tasks[count.index].family
}

resource "aws_ecs_task_definition" "tasks" {
 count = contains(var.environments, "production") ? length(var.app_names) : 0
 family = join("-", ["prod", var.app_names[count.index], "task"])
 container_definitions = <<TASK_DEFINITION
  [
   {
    "name": "${join("-", ["prod", var.app_names[count.index], "container"])}",
    "image": "${aws_ecr_repository.production[count.index].repository_url}",
    "memoryReservation": null,
    "resourceRequirements": null,
    "essential": true,
    "portMappings": [
     {
      "containerPort": 8080,
      "protocol": "tcp"
     }
    ],
    "environment": null,
    "secrets": null,
    "mountPoints": null,
    "volumesFrom": null,
    "hostname": null,
    "user": null,
    "workingDirectory": null,
    "extraHosts": null,
    "logConfiguration": {
     "logDriver": "awslogs",
     "options": {
      "awslogs-group": "${var.cloudwatch_groups[count.index]}",
      "awslogs-region": "${var.region}",
      "awslogs-stream-prefix": "ecs"
     }
    },
    "ulimits": null,
    "dockerLabels": null,
    "dependsOn": null
   }
  ]
  TASK_DEFINITION

 execution_role_arn = var.task_execution_role_arn
 task_role_arn = var.task_role_arn
 memory = 512
 cpu = 256
 network_mode = "awsvpc"
 requires_compatibilities = ["FARGATE"]

 tags = {
  "Name" = join("-", ["prod", var.app_names[count.index], "task"])
  "Environemt" = "production"
 }
}