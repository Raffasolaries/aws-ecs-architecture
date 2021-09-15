/* Load Balancer's Target groups */
resource "aws_lb_target_group" "instances" {
 count = contains(var.environments, "latest") ? length(var.apps) : 0
 name        = join("-", ["latest", var.apps[count.index].name, "tg"])
 port        = var.task_port
 protocol    = "HTTP"
 vpc_id      = var.vpc_id

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
  cookie_name = join("-", ["latest", var.apps[count.index].name, "alb"])
  type = "app_cookie"
 }

 tags = {
  Name = join("-", ["latest", var.apps[count.index].name, "tg"])
  Environment = "latest"
 }
}