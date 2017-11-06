
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
  default     = "81.97.16.0/24"
}
