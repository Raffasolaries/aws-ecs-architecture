/* HTTPS listener rules */
resource "aws_lb_listener_rule" "host_based_routing" {
 count = contains(var.environments, "latest") ? length(var.app_names) : 0
 listener_arn = var.alb_listener_https_default_arn
 priority     = 50000-((count.index+1)*2)

 action {
  type             = "forward"
  target_group_arn = aws_lb_target_group.instances[count.index].arn
 }

 condition {
  host_header {
   values = ["test-${var.app_names[count.index]}.${var.domain}"]
  }
 }
}