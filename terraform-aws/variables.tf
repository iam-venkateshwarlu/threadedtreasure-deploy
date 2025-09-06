variable "project" {
    default = "learn-VPC" 
}

variable "environment" {
    default = "dev"
  
}
variable "cidr" {
    default = "10.0.0.0/16"
}
variable "public_subnets" {
    default = ["10.0.0.0/24"]
}
variable "key_name" {
    default = "vscode"
  
}
#ec2
variable "instance_type" {
    default = "t2.micro"
  
}