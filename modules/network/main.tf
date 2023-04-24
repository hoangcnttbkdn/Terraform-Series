resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true

  tags = {
    "Name" = "${var.project_name}-vpc"
  }
}

resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet[count.index]
  map_public_ip_on_launch = false
  availability_zone       = var.availability_zone[count.index % length(var.availability_zone)]

  tags = {
    "Name" = "${var.project_name}-private-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone[count.index % length(var.availability_zone)]

  tags = {
    "Name" = "${var.project_name}-public-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    "Name" = "${var.project_name}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  tags = {
    "Name" = "${var.project_name}-public-rtb"
  }
}

resource "aws_route_table_association" "public_association" {
  for_each       = { for k, v in aws_subnet.public_subnet : k => v }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  count = var.create_nat_gateway ? 1 : 0
  vpc   = true
}

resource "aws_nat_gateway" "public" {
  depends_on = [aws_internet_gateway.ig]
  count      = var.create_nat_gateway ? 1 : 0

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public_subnet[0].id
  tags = {
    Name = "${var.project_name}-nat-gateway"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  dynamic "route" {
    for_each = var.create_nat_gateway ? [1] : []
    content {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.public[0].id
    }
  }

  tags = {
    "Name" = "${var.project_name}-private-rtb"
  }
}

resource "aws_route_table_association" "public_private" {
  for_each       = { for k, v in aws_subnet.private_subnet : k => v }
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

resource "aws_security_group" "public_sg" {
  name_prefix = "public_sg"
  description = "Allow SSH and Web traffic from the Internet"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
