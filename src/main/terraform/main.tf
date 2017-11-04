# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}

# Zone A/B VPC
module "aws_vpc" {
  source                = "./vpc"
  environment_name      = "${var.environment_name}"
  aws_region            = "${var.aws_region}"
  aws_key_name          = "${var.aws_key_name}"
  bastion_network_cidr  = "${var.bastion_network_cidr}"
}

# Green Zone A/B Aurora Cluster
module "aws_aurora_cluster" {
  source                     = "./aurora"
  environment_name           = "${var.environment_name}"
  vpc_id                     = "${module.aws_vpc.vpc_id}"
  vpc_rds_subnet_ids         = ["${module.aws_vpc.grn_sn_az_a_id}", "${module.aws_vpc.grn_sn_az_b_id}"]
  vpc_rds_security_group_id  = "${module.aws_vpc.grn_sg_id}"
  rds_database_name          = "${var.environment_name}db"
  rds_master_username        = "${var.environment_name}admin"
  rds_master_password        = "${var.environment_name}password"
}

# Amber Zone A docker customer jersey service host
module "aws_docker_amb_az_a" {
  source                       = "./docker"
  aws_key_name                 = "${var.aws_key_name}"
  aws_security_group_id        = "${module.aws_vpc.amb_sg_id}"
  aws_subnet_id                = "${module.aws_vpc.amb_sn_az_a_id}"
  docker_image                 = "sverze/aws-terraform-2-tier-service"
  docker_published_ports       = "-p 8080:8080"
  docker_environment_variables = "-e RDS_ENV_USERNAME='${var.environment_name}admin' -e RDS_ENV_PASSWORD='${var.environment_name}password' -e RDS_ENV_DB_NAME='${var.environment_name}db' -e RDS_ENV_CLUSTER_ENDPOINT='${module.aws_aurora_cluster.cluster_endpoint}' -e RDS_ENV_CLUSTER_PORT='${module.aws_aurora_cluster.cluster_port}'"
  depends_id                   = "${module.aws_aurora_cluster.depends_id}"
}

# Amber Zone B docker customer jersey service host
module "aws_docker_amb_az_b" {
  source                       = "./docker"
  aws_key_name                 = "${var.aws_key_name}"
  aws_security_group_id        = "${module.aws_vpc.amb_sg_id}"
  aws_subnet_id                = "${module.aws_vpc.amb_sn_az_b_id}"
  docker_image                 = "sverze/aws-terraform-2-tier-service"
  docker_published_ports       = "-p 8080:8080"
  docker_environment_variables = "-e RDS_ENV_USERNAME='${var.environment_name}admin' -e RDS_ENV_PASSWORD='${var.environment_name}password' -e RDS_ENV_DB_NAME='${var.environment_name}db' -e RDS_ENV_CLUSTER_ENDPOINT='${module.aws_aurora_cluster.cluster_endpoint}' -e RDS_ENV_CLUSTER_PORT='${module.aws_aurora_cluster.cluster_port}'"
  depends_id                   = "${module.aws_aurora_cluster.depends_id}"
}

# ELB serving Amber Zone A/B docker customer jersey service host
resource "aws_elb" "red_elb" {
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  security_groups             = ["${module.aws_vpc.red_sg_id}"]
  subnets                     = ["${module.aws_vpc.red_sn_az_a_id}", "${module.aws_vpc.red_sn_az_b_id}"]
  instances                   = ["${module.aws_docker_amb_az_a.instance_id}", "${module.aws_docker_amb_az_b.instance_id}"]

  listener {
    instance_port             = 8080
    instance_protocol         = "http"
    lb_port                   = 80
    lb_protocol               = "http"
  }

  health_check {
    healthy_threshold         = 2
    unhealthy_threshold       = 2
    timeout                   = 3
    target                    = "HTTP:8080/health"
    interval                  = 20
  }
}
