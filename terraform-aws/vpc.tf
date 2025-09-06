resource "aws_vpc" "main" {
    cidr_block = var.cidr
    enable_dns_hostnames = true
    enable_dns_support = true
  
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
  
}
resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnets[0]
    map_public_ip_on_launch = true
    availability_zone = "us-east-1a"
}
#route table
resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.main.id

}
resource "aws_route" "default_route" {
    route_table_id = aws_route_table.public_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}
#route table association
resource "aws_route_table_association" "public_assoc" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public_rt.id
}

#ec2 instance && security group
resource "aws_security_group" "ec2_sg" {
    vpc_id = aws_vpc.main.id
    name = "ec2_sg"
    description = "Allow SSH and HTTP"
  
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.project}-${var.environment}-sg" 
    }
}

resource "aws_instance" "web" {
    ami =  "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
    instance_type = var.instance_type
    subnet_id = aws_subnet.public.id
    vpc_security_group_ids = [aws_security_group.ec2_sg.id]
    associate_public_ip_address = true

    user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y nginx
              systemctl enable nginx
              systemctl start nginx
              echo "<h1>${var.project}-${var.environment} EC2 is running</h1>" > /usr/share/nginx/html/index.html
              EOF 

    tags = {
        Name = "${var.project}-${var.environment}-instance" 
    } 
}