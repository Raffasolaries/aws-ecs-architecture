output develop_name {
 value = aws_lb_target_group.develop.name
 description = "ALB target group develop name"
}

output latest_name {
 value = aws_lb_target_group.latest.name
 description = "ALB target group latest name"
}

output production_name {
 value = aws_lb_target_group.production.name
 description = "ALB target group production name"
}

output develop_arn {
 value = aws_lb_target_group.develop.arn
 description = "ALB target group develop ARN"
}

output latest_arn {
 value = aws_lb_target_group.latest.arn
 description = "ALB target group latest ARN"
}

output production_arn {
 value = aws_lb_target_group.production.arn
 description = "ALB target group production ARN"
}