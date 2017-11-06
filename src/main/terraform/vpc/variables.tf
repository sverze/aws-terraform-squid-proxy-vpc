
variable "environment_name" {
    description = "The name of the environment"
    default     = "dev"
}

variable "aws_region" {
  description = "AWS region to launch servers"
  default     = "eu-west-1"
}

variable "aws_public_vpc_cidr" {
  description = "VPC CIDR block range for the public VPC"
  default     = "10.1.0.0/16"
}

variable "aws_private_vpc_cidr" {
  description = "VPC CIDR block range for the private VPC"
  default     = "10.2.0.0/16"
}

variable "aws_sn_1_cidr" {
  description = "Subnet availability zone A CIDR block range for NAT gateways"
  default     = "10.1.1.0/24"
}

variable "aws_sn_2_cidr" {
  description = "Subnet availability zone B CIDR block range for NAT gateways"
  default     = "10.1.2.0/24"
}

variable "aws_sn_3_cidr" {
  description = "Subnet availability zone A CIDR block range for Squid proxies"
  default     = "10.1.3.0/24"
}

variable "aws_sn_4_cidr" {
  description = "Subnet availability zone B CIDR block range for Squid proxies"
  default     = "10.1.4.0/24"
}

variable "aws_sn_5_cidr" {
  description = "Subnet availability zone C CIDR block range for bastion instance"
  default     = "10.1.5.0/24"
}

variable "aws_sn_6_cidr" {
  description = "Subnet availability zone A CIDR block range for test instance"
  default     = "10.2.1.0/24"
}

variable "aws_sn_7_cidr" {
  description = "Subnet availability zone B CIDR block range for test instance"
  default     = "10.2.2.0/24"
}

variable "aws_key_name" {
  description = "AWS key name to use, it must exist in the specified region"
}


variable "bastion_network_cidr" {
  description = "Bastion network CIDR block range, refine default to makeaccess more secure"
  default     = "81.97.16.0/24"
}