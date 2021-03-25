output alb_target_group_develop_name {
 value = aws_lb_target_group.develop.name
 description = "ALB target group develop name"
}

output alb_target_group_latest_name {
 value = aws_lb_target_group.latest.name
 description = "ALB target group latest name"
}

output alb_target_group_production_name {
 value = aws_lb_target_group.production.name
 description = "ALB target group production name"
}

output alb_target_group_develop_arn {
 value = aws_lb_target_group.develop.arn
 description = "ALB target group develop ARN"
}

output alb_target_group_latest_arn {
 value = aws_lb_target_group.latest.arn
 description = "ALB target group latest name"
}

output alb_target_group_production_arn {
 value = aws_lb_target_group.production.arn
 description = "ALB target group production name"
}