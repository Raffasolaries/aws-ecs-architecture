data "aws_availability_zones" "available" {
 state = "available"
}
/*==== The VPC ======*/
resource "aws_vpc" "vpc" {
 count = var.environment == "develop" ? 1 : 0
 cidr_block           = var.vpc_cidr
 enable_dns_hostnames = true
 enable_dns_support   = true
 tags = {
  Name        = join("-", [var.environment, var.platform_name, "vpc"])
  Environment = var.environment
 }
}
/*==== Subnets ======*/
/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "ig" {
 count = var.environment == "develop" ? 1 : 0
 vpc_id = aws_vpc.vpc[0].id
 tags = {
   Name        = join("-", [var.environment, var.platform_name, "igw"])
   Environment = var.environment
 }
}
/* Elastic IP for NAT */
resource "aws_eip" "nat_eip" {
 count = var.environment == "develop" ? 1 : 0
 vpc        = true
 depends_on = [aws_internet_gateway.ig]
 tags = {
  Name = join("-", [var.environment, var.platform_name, "eip"])
  Environment = var.environment
 }
}
/* NAT */
resource "aws_nat_gateway" "nat" {
 count = var.environment == "develop" ? 1 : 0
 allocation_id = aws_eip.nat_eip[0].id
 subnet_id     = element(aws_subnet.public_subnet.*.id, 0)
 depends_on    = [aws_internet_gateway.ig]
 tags = {
  Name        = join("-", [var.environment, var.platform_name, "nat"])
  Environment = var.environment
 }
}
/* Private subnet */
resource "aws_subnet" "private_subnet" {
 count = var.environment == "develop" ? length(data.aws_availability_zones.available.names) : 0
 vpc_id = aws_vpc.vpc[0].id
 cidr_block              = cidrsubnet(var.vpc_cidr, var.subnets_newbits, count.index)
 availability_zone       = element(data.aws_availability_zones.available.names, count.index)
 map_public_ip_on_launch = false
 tags = {
  Name        = join("-", [var.environment, element(data.aws_availability_zones.available.names, count.index), "private-subnet"])
  Environment = var.environment
 }
}
/* Public subnet */
resource "aws_subnet" "public_subnet" {
 count = var.environment == "develop" ? length(data.aws_availability_zones.available.names) : 0
 vpc_id                  = aws_vpc.vpc[0].id
 cidr_block              = cidrsubnet(var.vpc_cidr, var.subnets_newbits, count.index+(length(data.aws_availability_zones.available.names)))
 availability_zone       = element(data.aws_availability_zones.available.names, count.index)
 map_public_ip_on_launch = true
 tags = {
  Name        = join("-", [var.environment, element(data.aws_availability_zones.available.names, count.index), "public-subnet"])
  Environment = var.environment
 }
}
/* Routing table for private subnet */
resource "aws_route_table" "private" {
 count = var.environment == "develop" ? 1 : 0
 vpc_id = aws_vpc.vpc[0].id
 tags = {
  Name        = join("-", [var.environment, var.platform_name, "private-rt"])
  Environment = var.environment
 }
}
/* Routing table for public subnet */
resource "aws_route_table" "public" {
 count = var.environment == "develop" ? 1 : 0
 vpc_id = aws_vpc.vpc[0].id
 tags = {
  Name        = join("-", [var.environment, var.platform_name, "public-rt"])
  Environment = var.environment
 }
}
/* Routes */
resource "aws_route" "public_internet_gateway" {
 count = var.environment == "develop" ? 1 : 0
 route_table_id         = aws_route_table.public[0].id
 destination_cidr_block = "0.0.0.0/0"
 gateway_id             = aws_internet_gateway.ig[0].id
}
resource "aws_route" "private_nat_gateway" {
 count = var.environment == "develop" ? 1 : 0
 route_table_id         = aws_route_table.private[0].id
 destination_cidr_block = "0.0.0.0/0"
 nat_gateway_id         = aws_nat_gateway.nat[0].id
}
/* Route table associations */
resource "aws_route_table_association" "public" {
 count          = var.environment == "develop" ? length(data.aws_availability_zones.available.names) : 0
 subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
 route_table_id = aws_route_table.public[0].id
}
resource "aws_route_table_association" "private" {
 count          = var.environment == "develop" ? length(data.aws_availability_zones.available.names) : 0
 subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
 route_table_id = aws_route_table.private[0].id
}
/*==== VPC's Default Security Group ======*/
resource "aws_security_group" "default" {
 count = var.environment == "develop" ? 1 : 0
 name        = join("-", [var.environment, var.platform_name, "default-sg"])
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
  Name = join("-", [var.environment, var.platform_name, "default-sg"])
  Environment = var.environment
 }
}