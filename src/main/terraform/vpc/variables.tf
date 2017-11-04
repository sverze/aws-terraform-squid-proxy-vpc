
variable "environment_name" {
    description = "The name of the environment"
    default     = "dev"
}

variable "aws_region" {
  description = "AWS region to launch servers"
  default     = "eu-west-2"
}

variable "aws_vpc_cidr" {
  description = "VPC CIDR block range"
  default     = "10.0.0.0/16"
}

variable "aws_red_sn_az_a_cidr" {
  description = "Red subnet availability zone A CIDR block range"
  default     = "10.0.1.0/24"
}

variable "aws_red_sn_az_b_cidr" {
  description = "Red subnet availability zone B CIDR block range"
  default     = "10.0.2.0/24"
}

variable "aws_amb_sn_az_a_cidr" {
  description = "Amber subnet availability zone A CIDR block range"
  default     = "10.0.3.0/24"
}

variable "aws_amb_sn_az_b_cidr" {
  description = "Amber subnet availability zone B CIDR block range"
  default     = "10.0.4.0/24"
}

variable "aws_grn_sn_az_a_cidr" {
  description = "Green subnet availability Zone A CIDR block range"
  default     = "10.0.5.0/24"
}

variable "aws_grn_sn_az_b_cidr" {
  description = "Green subnet availability Zone B CIDR block range"
  default     = "10.0.6.0/24"
}

variable "aws_key_name" {
  description = "AWS key name to use, it must exist in the specified region"
}

variable "bastion_network_cidr" {
  description = "Bastion network CIDR block range, refine default to makeaccess more secure"
  default     = "0.0.0.0/0"
}
