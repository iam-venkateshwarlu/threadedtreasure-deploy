output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id 
  
}
output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public.id 
}
output "ec2_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.web.id 
}
output "ec2_public_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.web.public_ip 
}