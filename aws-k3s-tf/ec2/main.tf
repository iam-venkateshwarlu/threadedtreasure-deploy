resource "aws_instance" "myapp" {
  ami           = "ami-08c40ec9ead489470" # Amazon Linux 2 AMI
  instance_type = var.instance_type.default
  subnet_id =  aws_subnet.public_subnet.id
  security_groups = [ aws_security_group.myapp_sg.name ]
  
  tags = {
    Name = "myapp-instance"
  }
  
}


# resource "aws_key_pair" "myapp_key" {
#   key_name   = "aws-login"
#   public_key = file("~/.ssh/id_rsa.pub")   # path to your local public key
# }
