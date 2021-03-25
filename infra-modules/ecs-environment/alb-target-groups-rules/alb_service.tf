# resource "aws_lb" "alb" {
#   name               = "${var.name}-lb"
#   internal           = true
#   load_balancer_type = "appication"
#   subnets            = var.private_subnet_ids

#   enable_deletion_protection = true

#   tags = {
#     Name = "${var.name}-lb"
#   }
# }

resource "aws_lb_target_group" "develop" {
  # depends_on  = [
  #   aws_lb.alb
  # ]
  name        = "${var.name_develop}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  stickiness {
   type = "lb_cookie"
  }

  tags = {
    Name = "${var.name_develop}-tg"
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_lb_listener_rule" "develop" {
 depends_on  = [
   aws_lb_target_group.develop
 ]
 listener_arn = var.listener_arn

 action {
  type = "forward"
  target_group_arn = aws_lb_target_group.develop.arn
 }

 condition {
   host_header {
     values = [var.host_header_develop]
   }
 }
}

resource "aws_lb_target_group" "latest" {
  # depends_on  = [
  #   aws_lb.alb
  # ]
  name        = "${var.name_latest}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  tags = {
    Name = "${var.name_latest}-tg"
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_lb_listener_rule" "latest" {
 depends_on  = [
   aws_lb_target_group.latest
 ]
 listener_arn = var.listener_arn

 action {
  type = "forward"
  target_group_arn = aws_lb_target_group.latest.arn
 }

 condition {
   host_header {
     values = [var.host_header_latest]
   }
 }
}

resource "aws_lb_target_group" "production" {
  # depends_on  = [
  #   aws_lb.alb
  # ]
  name        = "${var.name_production}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  tags = {
    "Name" = "${var.name_production}-tg"
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_lb_listener_rule" "production" {
 depends_on  = [
   aws_lb_target_group.production
 ]
 listener_arn = var.listener_arn

 action {
  type = "forward"
  target_group_arn = aws_lb_target_group.production.arn
 }

 condition {
   host_header {
     values = [var.host_header_production]
   }
 }
}