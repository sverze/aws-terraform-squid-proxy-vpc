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

variable "aws_subnet_ids" {
  description = "AWS subnet IDs that the launch configuration will use"
  type        = "list"
}

variable "aws_key_name" {
  description = "AWS key name to use, it must exist in the specified region"
}

variable "aws_ami" {
  description = "AWS AMI to use for the squid proxy hosts"
}

variable "aws_asg_min_size" {
  description = "Auto scale group minimum size"
  default     = 2
}

variable "aws_asg_max_size" {
  description = "Auto scale group maximum size"
  default     = 10
}

variable "squid_port" {
  description = "Squid proxies ELB port"
}

variable "depends_on" {
  description = "A list of reourse ID's that this module depends on in order to complete correctly"
  type        = "list"
  default     = []
}