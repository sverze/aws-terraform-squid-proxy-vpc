
variable "aws_region" {
  description = "AWS region to launch servers."
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


# AMazon Linux (x64)
variable "aws_amis" {
  default = {
    eu-west-1 = "ami-d7b9a2b1"
    eu-west-2 = "ami-ed100689"
  }
}

variable "docker_image" {
  description = "The docker image name, this must be available in docker hub registry"
}

variable "docker_published_ports" {
  description = "The docker images published container ports in the form '-p 8080:80 -p 8081:81'"
  default     = ""
}

variable "docker_environment_variables" {
  description = "A list of docker environment variable in the form '-e var1=foo -e var2=bar'"
  default     = ""
}

variable "depends_id" {
  description = "Use in case there is a module dependency you rely on before this instance starts"
  default     = ""
}