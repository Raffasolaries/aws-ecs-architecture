/* Gateway endpoints creation and association */
// S3
resource "aws_vpc_endpoint" "s3" {
 count = contains(var.environments, "develop") || contains(var.environments, "latest") ? 1 : 0
 vpc_id       = aws_vpc.vpc[0].id
 service_name = join(".", ["com.amazonaws", var.region, "s3"])
 tags = {
  Name = join("-", ["staging", var.platform_name, "s3-vpce"])
  Environment = "staging"
 }
}
// DynamoDB
resource "aws_vpc_endpoint" "dynamodb" {
 count = contains(var.environments, "develop")|| contains(var.environments, "latest") ? 1 : 0
 vpc_id       = aws_vpc.vpc[0].id
 service_name = join(".", ["com.amazonaws", var.region, "dynamodb"])

 tags = {
  Name = join("-", ["staging", var.platform_name, "dynamodb-vpce"])
  Environment = "staging"
 }
}
resource "aws_vpc_endpoint_route_table_association" "s3" {
 count = contains(var.environments, "develop") || contains(var.environments, "latest") ? 1 : 0
 route_table_id  = aws_route_table.private[0].id
 vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
}
resource "aws_vpc_endpoint_route_table_association" "dynamodb" {
 count = contains(var.environments, "develop") || contains(var.environments, "latest") ? 1 : 0
 route_table_id  = aws_route_table.private[0].id
 vpc_endpoint_id = aws_vpc_endpoint.dynamodb[0].id
}
# CloudWatch
resource "aws_vpc_endpoint" "cloudwatch" {
 count = contains(var.environments, "develop")|| contains(var.environments, "latest") ? 1 : 0
 vpc_id       = aws_vpc.vpc[0].id
 service_name = join(".", ["com.amazonaws", var.region, "logs"])
 vpc_endpoint_type = "Interface"
 subnet_ids = aws_subnet.private_subnet.*.id
 security_group_ids = [
  aws_security_group.vpce[0].id,
 ]
 tags = {
  Name = join("-", ["staging", var.platform_name, "cloudwatch-logs-vpce"])
  Environment = "staging"
 }
}
# ECR
resource "aws_vpc_endpoint" "ecr_dkr" {
 count = contains(var.environments, "develop") || contains(var.environments, "latest") ? 1 : 0
 vpc_id       = aws_vpc.vpc[0].id
 service_name = join(".", ["com.amazonaws", var.region, "ecr.dkr"])
 vpc_endpoint_type = "Interface"
 private_dns_enabled = true
 subnet_ids          = aws_subnet.private_subnet.*.id
 security_group_ids = [
  aws_security_group.vpce[0].id,
 ]
 tags = {
  Name = join("-", ["staging", var.platform_name, "ecr-vpce"])
  Environment = "staging"
 }
}