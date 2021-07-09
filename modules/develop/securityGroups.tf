resource "aws_security_group" "vpce" {
 count = var.environment == "develop" ? 1 : 0
 name        = join("-", [var.environment, var.platform_name, "vpce-sg"])
 description = "Allow all traffic from private subnets"
 vpc_id      = aws_vpc.vpc[0].id

 ingress {
  description      = "All instances in the private subnets"
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = [for i in range(length(data.aws_availability_zones.available.names)) : cidrsubnet(var.vpc_cidr, var.subnets_newbits, i)]
 }

 egress {
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
 }

 tags = {
  Name = join("-", [var.environment, var.platform_name, "vpce-sg"])
  Environment = var.environment
 }
}