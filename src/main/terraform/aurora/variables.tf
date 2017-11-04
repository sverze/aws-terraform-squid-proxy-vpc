
variable "environment_name" {
  description = "The name of the environment"
}

variable "vpc_id" {
  description = "The ID of the VPC that the RDS cluster will be created in"
}

variable "vpc_rds_subnet_ids" {
  type        = "list"
  description = "The ID's of the VPC subnets that the RDS cluster instances will be created in"
}

variable "vpc_rds_security_group_id" {
  description = "The ID of the security group that should be used for the RDS cluster instances"
}

variable "rds_cluster_instance_count" {
  description = "The number of instances to create in the RDS cluster"
  default     = "2"
}

variable "rds_database_name" {
  description = "The RDS database name"
}

variable "rds_master_username" {
  description = "The RDS master username"
}

variable "rds_master_password" {
  description = "The RDS master password"
}
