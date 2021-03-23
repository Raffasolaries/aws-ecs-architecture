resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 20
  min_capacity       = 1
  resource_id        = "service/clusterName/serviceName"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "${var.name_production}-service"
}

resource "aws_appautoscaling_policy" "ecs_policy" {
  name               = ""
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
   predefined_metric_specification {
     predefined_metric_type = "RDSReaderAverageCPUUtilization"
   }

   target_value       = 75
   scale_in_cooldown  = 300
   scale_out_cooldown = 300
 }
}