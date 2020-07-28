# Define our VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "APP_VCP"
  }
}

# Define the public subnet
resource "aws_subnet" "public-subnet" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr
  availability_zone = var.zone

  tags = {
    Name = "Nginx Public Subnet"
  }
}

# Define the private subnet
resource "aws_subnet" "private-subnet" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr
  availability_zone = var.zone

  tags = {
    Name = "Web Private Subnet"
  }
}

# Define the internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "VPC IGW"
  }
}

# Define the route table
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "PublicRT"
  }
}

# Define the route table
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "PrivateRT"
  }
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "public_route" {
  subnet_id = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public_route.id
}

# Assign the route table to the private Subnet
resource "aws_route_table_association" "private_route" {
  subnet_id = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private_route.id
}

# Define the security group for public subnet
resource "aws_security_group" "sgNginx" {
  name = "sgnginx"
  description = "Allow incoming HTTP connections & SSH access"


  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  vpc_id= aws_vpc.main.id

  tags = {
    Name = "Nginx SG"
  }
}

# Define the security group for private subnet
resource "aws_security_group" "sgWeb"{
  name = "sgweb"
  description = "Allow traffic from public subnet"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnet_cidr}"]
  }

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Web SG"
  }
}
