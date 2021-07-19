/* Target group */
// resource "aws_lb_target_group" "instance" {
//  name        = join("-", ["develop", var.app_name, "tg"])
//  port        = var.task_port
//  protocol    = "HTTP"
//  target_type = "instance"
//  vpc_id      = var.vpc_id

//  health_check {
//   matcher = "200-299"
//   path = "/"
//  }

//  stickiness {
//   enabled = true
//   type = "source_ip"
//  }

//  tags = {
//   Name = join("-", ["develop", var.app_name, "tg"])
//   Environment = "develop"
//  }
// }