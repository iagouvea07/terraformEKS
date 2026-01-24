resource "aws_vpc" "vpc_main" {
  cidr_block            = var.vpc_cidr_block
  enable_dns_hostnames  = true

  tags = {
    Name = "${var.prefix}-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                    = aws_vpc.vpc_main.id
  cidr_block                = var.public_subnet_cidr_block
  map_public_ip_on_launch   = true
  availability_zone         = "${var.region}a"

  tags = {
    Name = "${var.prefix}-public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                    = aws_vpc.vpc_main.id
  cidr_block                = var.private_subnet_cidr_block
  availability_zone         = "${var.region}b"

  tags = {
    Name = "${var.prefix}-private-subnet"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc_main.id

  tags = {
    Name = "${var.prefix}-internet-gateway"
  }
}

resource "aws_eip" "elastic_ip" {
  domain = "vpc"

  tags = {
    Name = "${var.prefix}-nat-ip"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "${var.prefix}-nat-gateway"
  }
}

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.vpc_main.id

    route {
        cidr_block = var.vpc_cidr_block
        gateway_id = "local"
    }

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }

    tags = {
      Name = "${var.prefix}-public-route-table"
    }
}

resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.vpc_main.id

    route {
        cidr_block = var.vpc_cidr_block
        gateway_id = "local"
    }

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat_gateway.id
    }

    tags = {
      Name = "${var.prefix}-private-route-table"
    }
}

resource "aws_route_table_association" "public_association" {
    subnet_id       = aws_subnet.public_subnet.id
    route_table_id  = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_association" {
    subnet_id       = aws_subnet.private_subnet.id
    route_table_id  = aws_route_table.private_route_table.id
}