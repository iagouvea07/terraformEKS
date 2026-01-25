resource "aws_vpc" "vpc_main" {
  cidr_block            = var.vpc.vpc_cidr_block
  enable_dns_hostnames  = true

  tags = {
    Name = "${var.global.prefix}-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                    = aws_vpc.vpc_main.id
  cidr_block                = var.vpc.public_subnet_cidr_block
  map_public_ip_on_launch   = true
  availability_zone         = "${var.global.region}a"

  tags = {
    Name = "${var.global.prefix}-public-subnet"
  }
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id                    = aws_vpc.vpc_main.id
  cidr_block                = var.vpc.private_subnet_cidr_block[0]
  availability_zone         = "${var.global.region}a"

  tags = {
    Name = "${var.global.prefix}-private-subnet-1"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id                    = aws_vpc.vpc_main.id
  cidr_block                = var.vpc.private_subnet_cidr_block[1]
  availability_zone         = "${var.global.region}b"

  tags = {
    Name = "${var.global.prefix}-private-subnet-2"
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc_main.id

  tags = {
    Name = "${var.global.prefix}-internet-gateway"
  }
}

resource "aws_eip" "elastic_ip" {
  domain = "vpc"

  tags = {
    Name = "${var.global.prefix}-nat-ip"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "${var.global.prefix}-nat-gateway"
  }
}

resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.vpc_main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.internet_gateway.id
    }

    tags = {
      Name = "${var.global.prefix}-public-route-table"
    }
}

resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.vpc_main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.nat_gateway.id
    }

    tags = {
      Name = "${var.global.prefix}-private-route-table"
    }
}

resource "aws_route_table_association" "public_association" {
    subnet_id       = aws_subnet.public_subnet.id
    route_table_id  = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_association_1" {
    subnet_id       = aws_subnet.private_subnet_1.id
    route_table_id  = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_association_2" {
    subnet_id       = aws_subnet.private_subnet_2.id
    route_table_id  = aws_route_table.private_route_table.id
}