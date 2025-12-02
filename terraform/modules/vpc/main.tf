############################################
# VPC
############################################
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-VPC"
    }
  )
}

############################################
# PUBLIC SUBNETS + IGW + PUBLIC ROUTING
############################################
resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidrs[0]
  availability_zone       = var.azs[0]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-public-subnet1"
    }
  )
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidrs[1]
  availability_zone       = var.azs[1]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-public-subnet2"
    }
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-igw"
    }
  )
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-public-route-table"
    }
  )
}

resource "aws_route" "public_default_internet" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_association1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_association2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_route_table.id
}

############################################
# PRIVATE SUBNETS + NAT + PRIVATE ROUTING
############################################
resource "aws_subnet" "private_subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet_cidrs[0]
  availability_zone       = var.azs[0]
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-private-subnet1"
    }
  )
}

resource "aws_subnet" "private_subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet_cidrs[1]
  availability_zone       = var.azs[1]
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-private-subnet2"
    }
  )
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-nat-eip"
    }
  )
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.allocation_id
  subnet_id     = aws_subnet.public_subnet1.id
  depends_on    = [aws_internet_gateway.igw]

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-nat-gateway"
    }
  )
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-private-route-table"
    }
  )
}

resource "aws_route_table_association" "private_association1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_association2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private_route_table.id
}
