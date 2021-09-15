/* Load Balancer's Target groups */
resource "aws_lb_target_group" "ips" {
 count = contains(var.environments, "production") ? length(var.apps) : 0
 name        = join("-", ["prod", var.apps[count.index].name, "tg"])
 port        = var.task_port
 protocol    = "HTTP"
 target_type = "ip"
 vpc_id      = aws_vpc.vpc[0].id

 health_check {
  healthy_threshold = 2
  unhealthy_threshold = 2
  timeout = 3
  interval = 30
  matcher = "200-299,301,302"
  path = "/"
 }

 stickiness {
  enabled = true
  cookie_name = join("-", ["prod", var.apps[count.index].name, "alb"])
  type = "app_cookie"
 }

 tags = {
  Name = join("-", ["prod", var.apps[count.index].name, "tg"])
  Environment = "production"
 }
}