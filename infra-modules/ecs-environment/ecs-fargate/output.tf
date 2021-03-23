output alb_arn {
  value       = aws_lb.alb.arn
  description = "ARN for the internal ALB"
}

output alb_dns_name {
  value       = aws_lb.alb.dns_name
  description = "DNS name for the internal NLB"
}