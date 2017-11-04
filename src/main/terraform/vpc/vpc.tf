# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}

# VPC to launch our instances into
resource "aws_vpc" "vpc" {
  cidr_block           = "${var.aws_vpc_cidr}"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags {
    Name               = "${var.environment_name}_vpc"
  }
}

# Internet Gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.environment_name}_internet_gateway"
  }
}

# VPC internet access on its main route table
resource "aws_route" "route" {
  route_table_id         = "${aws_vpc.vpc.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.internet_gateway.id}"
}

# Red Zone Subnet in Availability Zone A
resource "aws_subnet" "red_sn_az_a" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.aws_red_sn_az_a_cidr}"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags {
    Name                  = "${var.environment_name}_red_sn_az_a"
  }
}

# Red Zone Subnet in Availability Zone B
resource "aws_subnet" "red_sn_az_b" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.aws_red_sn_az_b_cidr}"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags {
    Name                  = "${var.environment_name}_red_sn_az_b"
  }
}

# Red Zone Security Group (Load Balances)
resource "aws_security_group" "red_sg" {
  name        = "${var.environment_name}_red_sg"
  vpc_id      = "${aws_vpc.vpc.id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP access from Amber Zone
  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${var.aws_amb_sn_az_a_cidr}", "${var.aws_amb_sn_az_b_cidr}"]
  }

  tags {
    Name        = "${var.environment_name}_red_sg"
  }
}

# Amber Zone Subnet in Availability Zone A
resource "aws_subnet" "amb_sn_az_a" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.aws_amb_sn_az_a_cidr}"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = true

  tags {
    Name                  = "${var.environment_name}_amb_sn_az_a"
  }
}

# Amber Zone Subnet in Availability Zone B
resource "aws_subnet" "amb_sn_az_b" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.aws_amb_sn_az_b_cidr}"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = true

  tags {
    Name                  = "${var.environment_name}_amb_sn_az_b"
  }
}

# Amber Zone Security Group
resource "aws_security_group" "amb_sg" {
  name        = "${var.environment_name}_amb_sg"
  vpc_id      = "${aws_vpc.vpc.id}"

  # HTTP access from Red Zone
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${var.aws_red_sn_az_a_cidr}", "${var.aws_red_sn_az_b_cidr}"]
  }

  # SSH access only from Bastion Network
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.bastion_network_cidr}"]
  }

  # TODO: Remove outbound too all the world
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "${var.environment_name}_amb_sg"
  }
}
# Green Zone Subnet in Availability Zone A
resource "aws_subnet" "grn_sn_az_a" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.aws_grn_sn_az_a_cidr}"
  availability_zone       = "${var.aws_region}a"
  map_public_ip_on_launch = false

  tags {
    Name                  = "${var.environment_name}_grn_sn_az_a"
  }
}

# Green Zone Subnet in Availability Zone B
resource "aws_subnet" "grn_sn_az_b" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.aws_grn_sn_az_b_cidr}"
  availability_zone       = "${var.aws_region}b"
  map_public_ip_on_launch = false

  tags {
    Name                  = "${var.environment_name}_grn_sn_az_b"
  }
}

# Green Zone Security Group
resource "aws_security_group" "grn_sg" {
  name        = "${var.environment_name}_grn_sg"
  vpc_id      = "${aws_vpc.vpc.id}"

  # SSH access only from Bastion Network
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.bastion_network_cidr}"]
  }

  # MySQL (Aurora) port access
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["${var.aws_amb_sn_az_a_cidr}", "${var.aws_amb_sn_az_b_cidr}"]
  }

  tags {
    Name        = "${var.environment_name}_grn_sg"
  }
}
