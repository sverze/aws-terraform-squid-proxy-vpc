variable "environment_name" {
  description = "The name of the environment"
}

variable "aws_region" {
  description = "AWS region to create the VPC and services"
}

variable "aws_profile" {
  description = "AWS profile to use other than the default"
  default     = "default"
}

variable "aws_key_name" {
  description = "AWS key name to use, it must exist in the specified region"
}

variable "aws_security_group_id" {
  description = "AWS security group ID that the instances will be bound to"
}

variable "aws_subnet_id" {
  description = "AWS subnet ID that the instance will be bound to"
}

variable "aws_ami" {
  description = "AWS AMI to use for the bastion host"
}

variable "aws_instance_type" {
  description = "The EC2 instance type"
  default     = "t2.micro"
}