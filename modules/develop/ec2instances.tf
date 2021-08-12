# find the AMI ECS Optimized
data "aws_ami_ids" "amazon" {
 count = contains(var.environments, "develop") || contains(var.environments, "latest") ? 1 : 0

 filter {
  name   = "name"
  values = ["amzn2-ami-ecs-hvm-2.0.20210802-x86_64-ebs"]
 }

 owners = ["amazon", "aws-marketplace"]
}
// ## Creating Launch Configuration
// resource "aws_launch_configuration" "ecs_optimized" {
//  count = contains(var.environments, "develop") || contains(var.environments, "latest") ? 1 : 0
//  image_id               = data.aws_ami_ids.amazon[0].ids[0]
//  instance_type          = "t2.micro"
//  security_groups        = [aws_security_group.instances[0].id]

//  lifecycle {
//   create_before_destroy = true
//  }
// }
// ## Placement Group
// resource "aws_placement_group" "ecs_optimized" {
//  count = contains(var.environments, "develop") || contains(var.environments, "latest") ? 1 : 0
//  name     = join("-", ["develop", var.platform_name, "pg"])
//  strategy = "spread"
// }
// ## Creating AutoScaling Group
// resource "aws_autoscaling_group" "ecs_optimized" {
//  count = contains(var.environments, "develop") || contains(var.environments, "latest") ? 1 : 0
//  launch_configuration = aws_launch_configuration.ecs_optimized[0].id
//  min_size = 2
//  max_size = 20
//  // target_group_arns = aws_lb_target_group.instances[*].arn
//  vpc_zone_identifier = aws_subnet.private_subnet[*].id
//  health_check_type = "ELB"
//  termination_policies = ["OldestInstance"]
//  placement_group = aws_placement_group.ecs_optimized[0].id

//  tag {
//   key = "Name"
//   value = join("-", ["staging", var.platform_name, "asg"])
//   propagate_at_launch = true
//  }
// }

resource "aws_instance" "web" {
 count = contains(var.environments, "develop") || contains(var.environments, "latest") ? 3 : 0
 ami           = data.aws_ami_ids.amazon[0].ids[0]
 // launch_template = aws_launch_configuration.ecs_optimized[0].id
 instance_type = "t3.micro"
 source_dest_check = false
 subnet_id                   = aws_subnet.private_subnet[count.index].id
 // placement_group = aws_placement_group.ecs_optimized[0].id

 monitoring = true

 user_data = <<EOF
   #!/bin/bash
   echo ECS_CLUSTER=${join("-", ["staging", var.platform_name])} >> /etc/ecs/ecs.config
  EOF

 vpc_security_group_ids = [aws_security_group.instances[0].id]

 root_block_device {
  encrypted = true
  volume_type = "gp3"
  volume_size = 30
 }

 tags = {
  Name = join("-", ["staging", var.platform_name, "instance"])
  Environment = "staging"
 }
}

