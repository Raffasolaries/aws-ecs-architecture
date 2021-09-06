/*==== ALB Security Group ======*/
resource "aws_security_group" "alb" {
 count = contains(var.environments, "production") ? 1 : 0
 name        = join("-", ["prod", var.platform_name, "alb-sg"])
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
  Name = join("-", ["prod", var.platform_name, "default-sg"])
  Environment = "production"
 }
}
/*==== VPC's Default Security Group ======*/
resource "aws_security_group" "default" {
 count = contains(var.environments, "production") ? 1 : 0
 name        = join("-", ["prod", var.platform_name, "default-sg"])
 description = "Default security group to allow inbound/outbound from the VPC"
 vpc_id      = aws_vpc.vpc[0].id
 depends_on  = [aws_vpc.vpc]

 ingress {
  from_port = "0"
  to_port   = "0"
  protocol  = "-1"
  self      = "true"
 }
 
 egress {
  from_port = "0"
  to_port   = "0"
  protocol  = "-1"
  self      = "true"
 }

 tags = {
  Name = join("-", ["prod", var.platform_name, "default-sg"])
  Environment = "production"
 }
}
# ECS Service security group
resource "aws_security_group" "instances" {
 count = contains(var.environments, "production") ? 1 : 0
 name        = join("-", ["prod", var.platform_name, "service-sg"])
 description = "Allows ECS services to communicate with Docker applications"
 vpc_id = aws_vpc.vpc[0].id

 ingress = [
  {
   description      = "Allows traffic in the same VPC"
   from_port        = 8080
   to_port          = 8080
   protocol         = "tcp"
   prefix_list_ids = []
   security_groups = []
   cidr_blocks      = [var.vpc_cidr]
   ipv6_cidr_blocks = []
   self = false
  }
 ]

 egress = [
  {
   description      = "Allows outbound traffic anywhere"
   from_port        = 0
   to_port          = 0
   protocol         = "-1"
   prefix_list_ids = [aws_vpc_endpoint.s3[0].prefix_list_id, aws_vpc_endpoint.dynamodb[0].prefix_list_id]
   security_groups = []
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
   self = false
  }
 ]

 tags = {
  Name = join("-", ["prod", var.platform_name, "service-sg"])
  Environment = "prod"
 }
}
/* Interface Endpoints Security Group */
resource "aws_security_group" "vpce" {
 count = contains(var.environments, "production") ? 1 : 0
 name        = join("-", ["prod", var.platform_name, "vpce-sg"])
 description = "Allow all traffic from private subnets"
 vpc_id      = aws_vpc.vpc[0].id

 ingress {
  description      = "All instances in the private subnets"
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = [for i in range(length(var.availability_zones)) : cidrsubnet(var.vpc_cidr, var.subnets_newbits, i)]
 }

 egress {
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
 }

 tags = {
  Name = join("-", ["prod", var.platform_name, "vpce-sg"])
  Environment = "production"
 }
}
