variable "environment_name" {
  description = "The name of the environment"
  default     = "dev"
}

variable "aws_instance_type" {
  description = "The EC2 instance type"
  default     = "t2.micro"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default     = "eu-west-1"
}

variable "aws_security_group_id" {
  description = "AWS security group ID that the instances will be bound to"
}

variable "aws_subnet_id" {
  description = "AWS subnet ID that the instance will be bound to"
}

variable "aws_key_name" {
  description = "AWS key name to use, it must exist in the specified region"
}

variable "aws_ami" {
  description = "AWS AMI to use for the application host"
}

variable "squid_proxies_uri" {
  description = "Squid proxies ELB URI"
}

variable "squid_proxies_port" {
  description = "Squid proxies ELB port"
}