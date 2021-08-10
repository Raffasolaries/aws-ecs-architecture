/* Load Balancer's Target groups */
resource "aws_lb_target_group" "ip" {
 count = contains(var.environments, "develop") ? length(var.app_names) : 0
 name        = join("-", ["develop", var.app_names[count.index], "tg"])
 port        = var.task_port
 protocol    = "HTTP"
 target_type = "ip"
 vpc_id      = aws_vpc.vpc[0].id

 health_check {
  matcher = "200-299"
  path = "/"
 }

 stickiness {
  enabled = true
  cookie_name = join("-", ["develop", var.app_names[count.index], "alb"])
  type = "app_cookie"
 }

 tags = {
  Name = join("-", ["develop", var.app_names[count.index], "tg"])
  Environment = "develop"
 }
}