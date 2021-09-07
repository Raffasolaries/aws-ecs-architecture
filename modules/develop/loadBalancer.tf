/* Application Load Balncer */
resource "aws_lb" "alb" {
 count = contains(var.environments, "develop") || contains(var.environments, "latest") ? 1 : 0
 name               = join("-", ["staging", var.platform_name, "alb"])
 internal           = false
 load_balancer_type = "application"
 security_groups    = [aws_security_group.alb[0].id]
 subnets            = aws_subnet.public_subnet[*].id

 enable_deletion_protection = false

 tags = {
  Name = join("-", ["staging", var.platform_name, "alb"])
  Environment = "staging"
 }
}
/* Default HTTP 80 redirect rule */
resource "aws_lb_listener" "http_redirect" {
 count = contains(var.environments, "develop") || contains(var.environments, "latest") ? 1 : 0
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
 count = contains(var.environments, "develop") || contains(var.environments, "latest") ? 1 : 0
 load_balancer_arn = aws_lb.alb[0].arn
 port              = 443
 protocol          = "HTTPS"

 default_action {
  type = "fixed-response"

  fixed_response {
   content_type = "text/plain"
   message_body = "Request not handled. Please configure custom listener."
   status_code  = 200
  }
 }
}
/* HTTPS Certificates */
resource "aws_lb_listener_certificate" "listener_certs" {
 count = contains(var.environments, "develop") || contains(var.environments, "latest") ? length(var.certificates_arn) : 0
 listener_arn    = aws_lb_listener.https_default[0].arn
 certificate_arn = var.certificates_arn[count.index]
}
/* HTTPS listener rules */
resource "aws_lb_listener_rule" "host_based_routing" {
 count = contains(var.environments, "develop") ? length(var.apps) : 0
 listener_arn = aws_lb_listener.https_default[0].arn
 priority     = 5000-count.index

 action {
  type             = "forward"
  target_group_arn = aws_lb_target_group.instances[count.index].arn
 }

 condition {
  host_header {
   values = ["dev-${var.apps[count.index].name}.${var.apps[count.index].domain}"]
  }
 }
}