# VPC
resource "aws_vpc" "myapp_vpc" {
  cidr_block           = var.vpc_cidr.default
  enable_dns_hostnames = true
  tags = { Name = "myapp-vpc" }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myapp_vpc.id
  tags   = { Name = "myapp-igw" }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.myapp_vpc.id
  cidr_block              = var.public_subnet_cidr.default
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
  tags = { Name = "myapp-public-subnet" }
}

# Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.myapp_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "myapp-public-rt" }
}

# Associate Subnet with Route Table
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}
