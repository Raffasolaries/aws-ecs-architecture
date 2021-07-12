/* Application Load Balncer */
resource "aws_lb" "alb" {
 count = var.environment == "develop" ? 1 : 0
 name               = join("-", [var.environment, var.platform_name, "alb"])
 internal           = false
 load_balancer_type = "application"
 security_groups    = [aws_security_group.alb[0].id]
 subnets            = aws_subnet.public_subnet[*].id

 enable_deletion_protection = true

 tags = {
  Name = join("-", [var.environment, var.platform_name, "alb"])
  Environment = var.environment
 }
}
/*==== ALB Security Group ======*/
resource "aws_security_group" "alb" {
 count = var.environment == "develop" ? 1 : 0
 name        = join("-", [var.environment, var.platform_name, "alb-sg"])
 description = "Application Load Balancer security group to allow inbound/outbound from HTTPS to ECS tasks"
 vpc_id      = aws_vpc.vpc[0].id
 depends_on  = [aws_vpc.vpc]

 ingress {
  from_port = 80
  to_port   = 0
  protocol  = "HTTP"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
 }

 ingress {
  from_port = 443
  to_port   = 0
  protocol  = "TLS"
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
  Name = join("-", [var.environment, var.platform_name, "default-sg"])
  Environment = var.environment
 }
}
/* Default HTTP 80 redirect rule */
resource "aws_lb_listener" "http_redirect" {
 count = var.environment == "develop" ? 1 : 0
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
 count = var.environment == "develop" ? 1 : 0
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