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

resource "aws_lb_target_group" "alb_tg" {
  # depends_on  = [
  #   aws_lb.alb
  # ]
  name        = "sva.go-${var.environment}-tg"
  port        = var.app_port
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

# Redirect all traffic from the ALB to the target group
resource "aws_lb_listener_rule" "host_based_routing" {
 depends_on  = [
   aws_lb_target_group.alb_tg
 ]
 listener_arn = var.listener_arn

 action {
  type = "forward"
  target_group_arn = aws_lb_target_group.alb_tg.arn
 }

 condition {
   host_header {
     values = [var.host_header]
   }
 }
}