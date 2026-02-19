locals {
  commonTags = {
    Name        = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = "Aman Dabral"
  }

  public_subnets = {
    for idx, cidr in var.public_subnets : var.availability_zones[idx] => cidr
  }

  private_subnets = {
    for idx, cidr in var.private_subnets : var.availability_zones[idx] => cidr
  }
}
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostname

  tags = merge(local.commonTags, {
    Name = "${var.project_name}-vpc"
  })
}

resource "aws_internet_gateway" "main_IGW" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.commonTags, {
    Name = "${var.project_name}-vpc"
  })
}

# PUBLIC SUBNET SETUP
resource "aws_subnet" "public_subnets" {
  for_each                = local.public_subnets
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = merge(local.commonTags, {
    Name = "${var.project_name}-public-subnet-${each.key}"
  })
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.commonTags, {
    Name = "${var.project_name}-public-route-table"
  })
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  gateway_id             = aws_internet_gateway.main_IGW.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_rtb_assoc" {
  for_each       = aws_subnet.public_subnets
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = each.value.id
}

# PRIVATE SUBNET SETUP
resource "aws_subnet" "private_subnets" {
  for_each          = local.private_subnets
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = each.key

  tags = merge(local.commonTags, {
    Name = "${var.project_name}-private-subnet-${each.key}"
  })
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  tags = merge(local.commonTags, {
    Name = "${var.project_name}-private-route-table"
  })
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  nat_gateway_id         = aws_nat_gateway.main_nat.id
  destination_cidr_block = "0.0.0.0/0"
}
resource "aws_route_table_association" "private_rtb_assoc" {
  for_each       = aws_subnet.private_subnets
  route_table_id = aws_route_table.private_route_table.id
  subnet_id      = each.value.id
}

# ELASTIC IP SETUP
resource "aws_eip" "nat_ip" {
  domain = "vpc"

  tags = merge(local.commonTags, {
    Name = "${var.project_name}-nat-eip"
  })

  depends_on = [aws_internet_gateway.main_IGW]
}

# NAT SETUP
resource "aws_nat_gateway" "main_nat" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public_subnets["ap-south-1a"].id

  tags = merge(local.commonTags, {
    Name = "${var.project_name}-nat-gateway"
  })

  depends_on = [aws_internet_gateway.main_IGW]
}



