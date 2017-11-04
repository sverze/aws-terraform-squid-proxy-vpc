
variable "aws_region" {
  description = "AWS region to launch servers"
  default     = "eu-west-2"
}

variable "aws_security_group_id" {
  description = "AWS security group ID that the instances will be bound to"
}

variable "aws_subnet_id" {
  description = "AWS subnet ID that the instances will be bound to"
}

variable "aws_key_name" {
  description = "AWS key name to use, it must exist in the specified region"
}


# Ubuntu Precise 12.04 LTS (x64)
variable "aws_amis" {
  default = {
    eu-west-1 = "ami-b1cf19c6"
    eu-west-2 = "ami-de2a3eba"
    us-east-1 = "ami-de7ab6b6"
    us-west-1 = "ami-3f75767a"
    us-west-2 = "ami-21f78e11"
  }
}
