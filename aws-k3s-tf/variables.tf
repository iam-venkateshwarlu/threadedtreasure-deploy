# variable "region" {
#     type       = string
#     default = "us-west-2"
#     description = "The AWS region to deploy the resources in"
# }

variable "instance_type" {
    default     = "t2.micro"
    description = "The instance type for the EC2 instances"
}

variable "vpc_cidr" {
    description = "The CIDR block for the admin IP range"
    default = "10.0.0.0/16"
}

variable "public_subent_cidr" {
    default = "10.0.1.0/24"
    description = "value for public subnet"
}

variable "key_name" {
    default = "aws-login"
    description = "The name of the key pair to use for EC2 instances"
  
}