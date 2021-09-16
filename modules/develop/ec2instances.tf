// # find the AMI ECS Optimized
// data "aws_ami_ids" "amazon" {
//  count = contains(var.environments, "develop") ? 1 : 0

//  filter {
//   name   = "name"
//   values = ["amzn2-ami-ecs-hvm-2.0.20210802-x86_64-ebs"]
//  }

//  owners = ["amazon", "aws-marketplace"]
// }

// resource "aws_instance" "web" {
//  count = contains(var.environments, "develop") ? length(var.apps) : 0
//  ami           = data.aws_ami_ids.amazon[0].ids[0]
//  // launch_template = aws_launch_configuration.ecs_optimized[0].id
//  instance_type = "t3.micro"
//  source_dest_check = false
//  subnet_id = aws_subnet.private_subnet[count.index % 3].id
//  iam_instance_profile = var.iam_instance_role_name

//  monitoring = true

//  user_data = <<EOF
//    #!/bin/bash
//    echo ECS_CLUSTER=${join("-", ["staging", var.platform_name])} >> /etc/ecs/ecs.config
//   EOF

//  vpc_security_group_ids = [aws_security_group.instances[0].id]

//  root_block_device {
//   encrypted = true
//   volume_type = "gp3"
//   volume_size = 30

//   tags = {
//    Name = join("-", ["staging", var.platform_name, "instance${count.index}"])
//    Environment = "staging"
//   }
//  }

//  tags = {
//   Name = join("-", ["staging", var.platform_name, "instance${count.index}"])
//   Environment = "staging"
//  }
// }

