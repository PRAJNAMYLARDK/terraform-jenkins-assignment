variable "aws_region" {
  type    = string
  default = "ap-south-2"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "availability_zone" {
  type    = string
  default = "ap-south-2a"
}

variable "vpc_name" {
  type    = string
  default = "terraform-assignment-vpc"
}
