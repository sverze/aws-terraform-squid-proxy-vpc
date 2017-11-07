
variable "environment_name" {
  description = "The name of the environment"
  default     = "dev"
}

variable "aws_region" {
  description = "AWS region to create the VPC and services"
  default     = "eu-west-1"
}

# NOTE: The key should be available via your SSH agent, use ssh-add to add this key
variable "aws_key_name" {
  description = "AWS key name to use, it must exist in the specified region"
  default = "sverze-dev"
}

variable "bastion_network_cidr" {
  description = "Bastion network CIDR block range, refine default to makeaccess more secure"
  default     = "0.0.0.0/0"
}

variable "squid_port" {
  description = "Squid proxies ELB port"
  default     = 3128
}

# Amazon Linux (x64)
variable "aws_amis" {
  type        = "map"
  default = {
    us-east-1 = "ami-8c1be5f6"
    us-east-2 = "ami-c5062ba0"
    eu-west-1 = "ami-acd005d5"
    eu-west-2 = "ami-1a7f6d7e"
  }
}
