provider "aws" {
  region = "us-east-1" # change if needed
}

# -------------------------
# VPC
# -------------------------
resource "aws_vpc" "myapp_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "myapp-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myapp_vpc.id

  tags = {
    Name = "myapp-igw"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.myapp_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "myapp-public-subnet"
  }
}

# Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.myapp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "myapp-public-rt"
  }
}

# Associate Subnet with Route Table
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# -------------------------
# Security Group
# -------------------------
resource "aws_security_group" "myapp_sg" {
  vpc_id = aws_vpc.myapp_vpc.id
  name   = "myapp-sg"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow APP Port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "myapp-sg"
  }
}

# -------------------------
# EC2 Instance
# -------------------------
resource "aws_instance" "myapp" {
  ami                         = "ami-08c40ec9ead489470" # Amazon Linux 2 in us-east-2
  instance_type               = "t2.micro"
  key_name                    = "vscode"               # must exist in AWS
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.myapp_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "myapp-instance"
  }
}

# -------------------------
# Outputs
# -------------------------
output "instance_public_ip" {
  value = aws_instance.myapp.public_ip
}

output "instance_id" {
  value = aws_instance.myapp.id
}
