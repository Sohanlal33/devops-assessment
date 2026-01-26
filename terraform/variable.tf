variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "ami_id" {
  description = "Ubuntu AMI ID"
  type        = string
  default     = "ami-019715e0d74f695be" 
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro" 
}

variable "key_name" {
  description = "SSH Key Pair name"
  type        = string
  default     = "nexgen-1"
}
