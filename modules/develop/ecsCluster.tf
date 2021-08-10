# Creating Cluster and enabling logs
resource "aws_kms_key" "cluster_logs_key" {
 count = contains(var.environments, "develop") || contains(var.environments, "latest") ? 1 : 0
 description             = join(" ", ["Staging", var.platform_name, "ECS Cluster logs key"])
 deletion_window_in_days = 7
}

resource "aws_cloudwatch_log_group" "cluster_logs_key" {
 count = contains(var.environments, "develop") || contains(var.environments, "latest") ? 1 : 0
 name = join("-", ["staging", var.platform_name, "ecs-cluster-logs"])
}

resource "aws_ecs_cluster" "staging" {
 count = contains(var.environments, "develop") || contains(var.environments, "latest") ? 1 : 0
 name = join("-", ["staging", var.platform_name])

 configuration {
  execute_command_configuration {
   kms_key_id = aws_kms_key.cluster_logs_key[0].arn
   logging    = "OVERRIDE"

   log_configuration {
    cloud_watch_encryption_enabled = true
    cloud_watch_log_group_name     = aws_cloudwatch_log_group.cluster_logs_key[0].name
   }
  }
 }

 setting {
  name = "containerInsights"
  value = "enabled"
 }

 tags = {
  Name = join("-", ["staging", var.platform_name])
  Environment = "staging"
 }
}