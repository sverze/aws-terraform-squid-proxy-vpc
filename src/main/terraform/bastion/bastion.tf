# Specify the provider and access details
provider "aws" {
  region                       = "${var.aws_region}"
  profile                      = "${var.aws_profile}"
}

resource "aws_instance" "bastion" {
  instance_type                = "${var.aws_instance_type}"
  ami                          = "${var.aws_ami}"
  key_name                     = "${var.aws_key_name}"
  vpc_security_group_ids       = ["${var.aws_security_group_id}"]
  subnet_id                    = "${var.aws_subnet_id}"
  associate_public_ip_address  = true

  tags {
    Name                       = "${var.environment_name}_bastion"
  }
}
