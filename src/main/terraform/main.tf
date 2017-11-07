# TODO - fix squid proxy whitelisting
# TODO - fix NAT gateway timeing issue

# Specify the provider and access details
provider "aws" {
  region               = "${var.aws_region}"
}

# Sets up the entire network including gateways
module "aws_vpc" {
  source                = "./vpc"
  environment_name      = "${var.environment_name}"
  aws_region            = "${var.aws_region}"
  aws_key_name          = "${var.aws_key_name}"
  bastion_network_cidr  = "${var.bastion_network_cidr}"
}

# Squid proxies auto scale group and ELB
module "squid" {
  source                = "./squid"
  aws_key_name          = "${var.aws_key_name}"
  aws_security_group_id = "${module.aws_vpc.sg_3_id}"
  aws_subnet_ids        = ["${module.aws_vpc.sn_3_id}", "${module.aws_vpc.sn_4_id}"]
  aws_ami               = "${lookup(var.aws_amis, var.aws_region)}"
  squid_port            = "${var.squid_port}"
  depends_on            = ["${module.aws_vpc.ng_1_id}", "${module.aws_vpc.ng_2_id}"]
}

# Bastion host accessible from the public subnet
module "bastion_host" {
  source                = "./bastion"
  aws_key_name          = "${var.aws_key_name}"
  aws_security_group_id = "${module.aws_vpc.sg_1_id}"
  aws_subnet_id         = "${module.aws_vpc.sn_5_id}"
  aws_ami               = "${lookup(var.aws_amis, var.aws_region)}"
}

# Application host for testing squid proxy access
module "application_host" {
  source                = "./application"
  aws_key_name          = "${var.aws_key_name}"
  aws_security_group_id = "${module.aws_vpc.sg_2_id}"
  aws_subnet_id         = "${module.aws_vpc.sn_6_id}"
  aws_ami               = "${lookup(var.aws_amis, var.aws_region)}"
  squid_dns_name        = "${module.squid.dns_name}"
  squid_port            = "${var.squid_port}"
}