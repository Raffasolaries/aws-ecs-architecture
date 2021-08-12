/*==== The VPC ======*/
resource "aws_vpc" "vpc" {
 count = contains(var.environments, "develop") || contains(var.environments, "latest") ? 1 : 0
 cidr_block           = var.vpc_cidr
 enable_dns_hostnames = true
 enable_dns_support   = true
 tags = {
  Name        = join("-", ["staging", var.platform_name, "vpc"])
  Environment = "staging"
 }
}
/*==== Subnets ======*/
/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "ig" {
 count = contains(var.environments, "develop") || contains(var.environments, "latest") ? 1 : 0
 vpc_id = aws_vpc.vpc[0].id
 tags = {
   Name        = join("-", ["staging", var.platform_name, "igw"])
   Environment = "staging"
 }
}
/* Elastic IP for NAT */
resource "aws_eip" "nat_eip" {
 count = contains(var.environments, "develop") || contains(var.environments, "latest") ? 1 : 0
 vpc        = true
 depends_on = [aws_internet_gateway.ig]
 tags = {
  Name = join("-", ["staging", var.platform_name, "eip"])
  Environment = "staging"
 }
}
/* NAT */
resource "aws_nat_gateway" "nat" {
 count = contains(var.environments, "develop") || contains(var.environments, "latest") ? 1 : 0
 allocation_id = aws_eip.nat_eip[0].id
 subnet_id     = element(aws_subnet.public_subnet[*].id, 0)
 depends_on    = [aws_internet_gateway.ig]
 tags = {
  Name        = join("-", ["staging", var.platform_name, "nat"])
  Environment = "staging"
 }
}
/* Private subnet */
resource "aws_subnet" "private_subnet" {
 count = contains(var.environments, "develop") || contains(var.environments, "latest") ? length(var.availability_zones) : 0
 vpc_id = aws_vpc.vpc[0].id
 cidr_block              = cidrsubnet(var.vpc_cidr, var.subnets_newbits, count.index)
 availability_zone       = element(var.availability_zones, count.index)
 map_public_ip_on_launch = false
 tags = {
  Name        = join("-", ["staging", element(var.availability_zones, count.index), "private-subnet"])
  Environment = "staging"
 }
}
/* Public subnet */
resource "aws_subnet" "public_subnet" {
 count = contains(var.environments, "develop") || contains(var.environments, "latest") ? length(var.availability_zones) : 0
 vpc_id                  = aws_vpc.vpc[0].id
 cidr_block              = cidrsubnet(var.vpc_cidr, var.subnets_newbits, count.index+(length(var.availability_zones)))
 availability_zone       = element(var.availability_zones, count.index)
 map_public_ip_on_launch = true
 tags = {
  Name        = join("-", ["staging", element(var.availability_zones, count.index), "public-subnet"])
  Environment = "staging"
 }
}
/* Routing table for private subnet */
resource "aws_route_table" "private" {
 count = contains(var.environments, "develop") || contains(var.environments, "latest") ? 1 : 0
 vpc_id = aws_vpc.vpc[0].id
 tags = {
  Name        = join("-", ["staging", var.platform_name, "private-rt"])
  Environment = "staging"
 }
}
/* Routing table for public subnet */
resource "aws_route_table" "public" {
 count = contains(var.environments, "develop") || contains(var.environments, "latest") ? 1 : 0
 vpc_id = aws_vpc.vpc[0].id
 tags = {
  Name        = join("-", ["staging", var.platform_name, "public-rt"])
  Environment = "staging"
 }
}
/* Routes */
resource "aws_route" "public_internet_gateway" {
 count = contains(var.environments, "develop") || contains(var.environments, "latest") ? 1 : 0
 route_table_id         = aws_route_table.public[0].id
 destination_cidr_block = "0.0.0.0/0"
 gateway_id             = aws_internet_gateway.ig[0].id
}
resource "aws_route" "private_nat_gateway" {
 count = contains(var.environments, "develop") || contains(var.environments, "latest") ? 1 : 0
 route_table_id         = aws_route_table.private[0].id
 destination_cidr_block = "0.0.0.0/0"
 nat_gateway_id         = aws_nat_gateway.nat[0].id
}
/* Route table associations */
resource "aws_route_table_association" "public" {
 count          = contains(var.environments, "develop") || contains(var.environments, "latest") ? length(var.availability_zones) : 0
 subnet_id      = aws_subnet.public_subnet[count.index].id
 route_table_id = aws_route_table.public[0].id
}
resource "aws_route_table_association" "private" {
 count          = contains(var.environments, "develop") || contains(var.environments, "latest") ? length(var.availability_zones) : 0
 subnet_id      = aws_subnet.private_subnet[count.index].id
 route_table_id = aws_route_table.private[0].id
}