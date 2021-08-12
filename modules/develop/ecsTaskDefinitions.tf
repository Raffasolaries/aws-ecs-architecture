resource "aws_ecs_task_definition" "tasks" {
 count = contains(var.environments, "develop") ? length(var.app_names) : 0
 family = join("-", ["develop", var.app_names[count.index], "task"])
 container_definitions = <<TASK_DEFINITION
  [
   {
    "name": "${join("-", ["develop", var.app_names[count.index], "container"])}",
    "image": "${aws_ecr_repository.staging[count.index].name}",
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
      "awslogs-group": "${join("-", ["/ecs/develop", var.app_names[count.index], "task"])}",
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
 requires_compatibilities = ["EC2"]

 placement_constraints {
  type       = "memberOf"
  expression = join("", ["attribute:ecs.availability-zone in [", join(", ", var.availability_zones), "]"])
 }

 tags = {
  "Name" = join("-", ["develop", var.app_names[count.index], "task"])
  "Environemt" = "develop"
 }
}