resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 20
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_service.production.name}/${aws_ecs_service.production.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on  = [
   aws_ecs_service.production
 ]
}

resource "aws_appautoscaling_policy" "ecs_policy" {
  name               = "RequestCountPerTarget"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
   predefined_metric_specification {
     predefined_metric_type = "ALBRequestCountPerTarget"
   }

   target_value       = 200
   scale_in_cooldown  = 300
   scale_out_cooldown = 2
 }
}