/**
 * This module sets up CPU-based autoscaling.  The number of containers
 * is kept strictly within the range you specify.  Within that range,
 * the number is gradually increased or decreased to keep CPU utilization
 * within its own range.  If your app is CPU-bound, the number of
 * instances will autoscale with your traffic.
 *
 * The adjustments are gradual.  If you expect a sudden surge of
 * traffic for a scheduled event (such as sporting events or elections),
 * set the `ecs_autoscale_min_instances` variable to a higher number.
 * `ecs_autoscale_max_instances` might also need to be increased, because
 * it should never be below ecs_autoscale_min_instances.
 *
 * To effectively disable autoscaling, set `ecs_autoscale_min_instances`
 * and `ecs_autoscale_max_instances` to the same number (your desired
 * number of containers).
 *
 * Note the default value of `ecs_autoscale_min_instances` is 1.  For
 * production, consider using a higher number.
 *
 * There should be a [considerable gap](https://en.wikipedia.org/wiki/Deadband) between
 * `ecs_as_cpu_low_threshold_per` and
 * `ecs_as_cpu_high_threshold_per` so that the number of
 * containers is not continually being autoscaled up and down.   If
 * `ecs_autoscale_min_instances==1`, then
 * `ecs_as_cpu_high_threshold_per` should be more than
 * twice ecs_as_cpu_low_threshold_per`.
 *
 * In the CloudWatch section of the AWS Console, you will often see the
 * alarms created by this module in an ALARM state, which are displayed in
 * red.  This is normal and does not indicate a problem.
 * On the page listing all the alarms, click the checkbox labelled
 * "Hide all AutoScaling alarms".
 *
 */

# If the average CPU utilization over a minute drops to this threshold,
# the number of containers will be reduced (but not below ecs_autoscale_min_instances).

# If the average CPU utilization over a minute rises to this threshold,
# the number of containers will be increased (but not above ecs_autoscale_max_instances).

locals {
 ecs_as_cpu_low_threshold_per = "20"
 ecs_as_cpu_high_threshold_per = "80"
 min_capacity = 1
 max_capacity = 10
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_high" {
 count = contains(var.environments, "production") ? length(var.app_names) : 0
 alarm_name          = "prod-${var.app_names[count.index]}-CPU-Utilization-High-${local.ecs_as_cpu_high_threshold_per}"
 comparison_operator = "GreaterThanOrEqualToThreshold"
 evaluation_periods  = "1"
 metric_name         = "CPUUtilization"
 namespace           = "AWS/ECS"
 period              = "60"
 statistic           = "Average"
 threshold           = local.ecs_as_cpu_high_threshold_per

 dimensions = {
  ClusterName = aws_ecs_cluster.production[0].name
  ServiceName = aws_ecs_service.services[count.index].name
 }

 alarm_actions = [aws_appautoscaling_policy.app_up[count.index].arn]
 tags = {
  Name = "prod-${var.app_names[count.index]}-CPU-Utilization-High-${local.ecs_as_cpu_high_threshold_per}"
  Environment = "production"
 }
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_low" {
 count = contains(var.environments, "production") ? length(var.app_names) : 0
 alarm_name          = "prod-${var.app_names[count.index]}-CPU-Utilization-Low-${local.ecs_as_cpu_low_threshold_per}"
 comparison_operator = "LessThanThreshold"
 evaluation_periods  = "1"
 metric_name         = "CPUUtilization"
 namespace           = "AWS/ECS"
 period              = "60"
 statistic           = "Average"
 threshold           = local.ecs_as_cpu_low_threshold_per

 dimensions = {
  ClusterName = aws_ecs_cluster.production[0].name
  ServiceName = aws_ecs_service.services[count.index].name
 }

 alarm_actions = [aws_appautoscaling_policy.app_down[count.index].arn]
 tags = {
  Name = "prod-${var.app_names[count.index]}-CPU-Utilization-Low-${local.ecs_as_cpu_low_threshold_per}"
  Environment = "production"
 }
}

resource "aws_appautoscaling_policy" "app_up" {
 count = contains(var.environments, "production") ? length(var.app_names) : 0
 name               = "prod-${var.app_names[count.index]}-scale-up"
 service_namespace  = aws_appautoscaling_target.ecs_target[count.index].service_namespace
 resource_id        = aws_appautoscaling_target.ecs_target[count.index].resource_id
 scalable_dimension = aws_appautoscaling_target.ecs_target[count.index].scalable_dimension

 step_scaling_policy_configuration {
  adjustment_type         = "ChangeInCapacity"
  cooldown                = 60
  metric_aggregation_type = "Average"

  step_adjustment {
   metric_interval_lower_bound = 0
   scaling_adjustment          = 1
  }
 }
}

resource "aws_appautoscaling_policy" "app_down" {
 count = contains(var.environments, "production") ? length(var.app_names) : 0
 name               = "prod-${var.app_names[count.index]}-scale-down"
 service_namespace  = aws_appautoscaling_target.ecs_target[count.index].service_namespace
 resource_id        = aws_appautoscaling_target.ecs_target[count.index].resource_id
 scalable_dimension = aws_appautoscaling_target.ecs_target[count.index].scalable_dimension

 step_scaling_policy_configuration {
  adjustment_type         = "ChangeInCapacity"
  cooldown                = 300
  metric_aggregation_type = "Average"

  step_adjustment {
   metric_interval_upper_bound = 0
   scaling_adjustment          = -1
  }
 }
}

resource "aws_appautoscaling_target" "ecs_target" {
 count = contains(var.environments, "production") ? length(var.app_names) : 0
 max_capacity       = local.max_capacity
 min_capacity       = local.min_capacity
 resource_id        = "service/${aws_ecs_cluster.production[0].name}/${aws_ecs_service.services[count.index].name}"
 scalable_dimension = "ecs:service:DesiredCount"
 service_namespace  = "ecs"
}