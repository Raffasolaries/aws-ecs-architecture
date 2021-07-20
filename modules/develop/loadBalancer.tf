/* Application Load Balncer */
resource "aws_lb" "alb" {
 count = contains(var.environments, "develop") ? 1 : 0
 name               = join("-", ["develop", var.platform_name, "alb"])
 internal           = false
 load_balancer_type = "application"
 security_groups    = [aws_security_group.alb[0].id]
 subnets            = aws_subnet.public_subnet[*].id

 enable_deletion_protection = false

 tags = {
  Name = join("-", ["develop", var.platform_name, "alb"])
  Environment = "develop"
 }
}
/*==== ALB Security Group ======*/
resource "aws_security_group" "alb" {
 count = contains(var.environments, "develop") ? 1 : 0
 name        = join("-", ["develop", var.platform_name, "alb-sg"])
 description = "Application Load Balancer security group to allow inbound/outbound from HTTPS to ECS tasks"
 vpc_id      = aws_vpc.vpc[0].id
 depends_on  = [aws_vpc.vpc]

 ingress {
  from_port = 80
  to_port   = 80
  protocol  = "TCP"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
 }

 ingress {
  from_port = 443
  to_port   = 443
  protocol  = "TCP"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
 }
 
 egress {
  from_port = 0
  to_port   = 0
  protocol  = -1
  cidr_blocks      = ["0.0.0.0/0"]
 }

 tags = {
  Name = join("-", ["develop", var.platform_name, "default-sg"])
  Environment = "develop"
 }
}
/* Default HTTP 80 redirect rule */
resource "aws_lb_listener" "http_redirect" {
 count = contains(var.environments, "develop") ? 1 : 0
 load_balancer_arn = aws_lb.alb[0].arn
 port              = 80
 protocol          = "HTTP"

 default_action {
  type = "redirect"

  redirect {
   port        = 443
   protocol    = "HTTPS"
   status_code = "HTTP_301"
  }
 }
}
/* Default Action HTTPS not routed */
resource "aws_lb_listener" "https_default" {
 count = contains(var.environments, "develop") ? 1 : 0
 load_balancer_arn = aws_lb.alb[0].arn
 port              = 443
 protocol          = "HTTPS"
 certificate_arn = var.certificate_arn

 default_action {
  type = "fixed-response"

  fixed_response {
   content_type = "text/plain"
   message_body = "Request not handled. Please configure custom listener."
   status_code  = 200
  }
 }
}
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
/* HTTPS listener rules */
resource "aws_lb_listener_rule" "host_based_routing" {
 count = contains(var.environments, "develop") ? length(var.app_names) : 0
 listener_arn = aws_lb_listener.https_default[0].arn
 priority     = 100

 action {
  type             = "forward"
  target_group_arn = aws_lb_target_group.ip[count.index].arn
 }

 condition {
  host_header {
   values = [join(".", [var.app_names[count.index], var.domain])]
  }
 }
}