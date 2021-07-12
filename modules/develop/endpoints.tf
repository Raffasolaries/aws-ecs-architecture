/* Gateway endpoints creation and association */
// S3
resource "aws_vpc_endpoint" "s3" {
 count = var.environment == "develop" ? 1 : 0
 vpc_id       = aws_vpc.vpc[0].id
 service_name = join(".", ["com.amazonaws", var.region, "s3"])
 tags = {
  Name = join("-", [var.environment, var.platform_name, "s3-vpce"])
  Environment = var.environment
 }
}
// DynamoDB
resource "aws_vpc_endpoint" "dynamodb" {
 count = var.environment == "develop" ? 1 : 0
 vpc_id       = aws_vpc.vpc[0].id
 service_name = join(".", ["com.amazonaws", var.region, "dynamodb"])

 tags = {
  Name = join("-", [var.environment, var.platform_name, "dynamodb-vpce"])
  Environment = var.environment
 }
}
resource "aws_vpc_endpoint_route_table_association" "s3" {
 count = var.environment == "develop" ? 1 : 0
 route_table_id  = aws_route_table.private[0].id
 vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
}
resource "aws_vpc_endpoint_route_table_association" "dynamodb" {
 count = var.environment == "develop" ? 1 : 0
 route_table_id  = aws_route_table.private[0].id
 vpc_endpoint_id = aws_vpc_endpoint.dynamodb[0].id
}
# CloudWatch
resource "aws_vpc_endpoint" "cloudwatch" {
 count = var.environment == "develop" ? 1 : 0
 vpc_id       = aws_vpc.vpc[0].id
 service_name = join(".", ["com.amazonaws", var.region, "logs"])
 vpc_endpoint_type = "Interface"
 subnet_ids = aws_subnet.private_subnet.*.id
 security_group_ids = [
  aws_security_group.vpce[0].id,
 ]
 tags = {
  Name = join("-", [var.environment, var.platform_name, "cloudwatch-logs-vpce"])
  Environment = var.environment
 }
}
# ECR
resource "aws_vpc_endpoint" "ecr_dkr" {
 count = var.environment == "develop" ? 1 : 0
 vpc_id       = aws_vpc.vpc[0].id
 service_name = join(".", ["com.amazonaws", var.region, "ecr.dkr"])
 vpc_endpoint_type = "Interface"
 private_dns_enabled = true
 subnet_ids          = aws_subnet.private_subnet.*.id
 security_group_ids = [
  aws_security_group.vpce[0].id,
 ]
 tags = {
  Name = join("-", [var.environment, var.platform_name, "ecr-vpce"])
  Environment = var.environment
 }
}
/* Interface Endpoints Security Group */
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
  cidr_blocks      = [for i in range(length(data.aws_availability_zones.available[0].names)) : cidrsubnet(var.vpc_cidr, var.subnets_newbits, i)]
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
