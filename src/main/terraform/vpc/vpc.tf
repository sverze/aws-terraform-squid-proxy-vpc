# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}

################        VPC        ################


# Public VPC required for NAT gateways and Squid Proxies
resource "aws_vpc" "vpc_1" {
  cidr_block               = "${var.aws_public_vpc_cidr}"
  enable_dns_support       = "true"
  enable_dns_hostnames     = "true"

  tags {
    Name                   = "${var.environment_name}_vpc_1"
  }
}

# Private VPC to launch our test instances into
resource "aws_vpc" "vpc_2" {
  cidr_block               = "${var.aws_private_vpc_cidr}"
  enable_dns_support       = "true"
  enable_dns_hostnames     = "true"

  tags {
    Name                   = "${var.environment_name}_vpc_2"
  }
}

# Private VPC to launch our test instances into
resource "aws_vpc_peering_connection" "pc_1" {
  peer_vpc_id              = "${aws_vpc.vpc_2.id}"
  vpc_id                   = "${aws_vpc.vpc_1.id}"
  auto_accept              = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags {
    Name                   = "${var.environment_name}_pc_1"
  }
}


################ Internet Gateway  ################


# TODO - Consider changing to egresss only gateway
# Internet Gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "ig_1" {
  vpc_id                   = "${aws_vpc.vpc_1.id}"

  tags {
    Name                   = "${var.environment_name}_ig_1"
  }
}

################    NAT Gateways   ################

# TODO - Get the gateways in place

################   Route Tables    ################


# Route Table for Internet access
resource "aws_route_table" "rt_1" {
  vpc_id                   = "${aws_vpc.vpc_1.id}"

  route {
    cidr_block             = "0.0.0.0/0"
    gateway_id             = "${aws_internet_gateway.ig_1.id}"
  }

  tags {
    Name                   = "${var.environment_name}_rt_1"
  }
}

# Route Table for Squid 1 / NAT / PC
resource "aws_route_table" "rt_2" {
  vpc_id                   = "${aws_vpc.vpc_1.id}"

  // TODO - route to NAT gateway

  route {
    cidr_block             = "10.2.0.0/16"
    gateway_id             = "${aws_vpc_peering_connection.pc_1.id}"
  }

  tags {
    Name                   = "${var.environment_name}_rt_2"
  }
}

# Route Table for Squid 2 / NAT / PC
resource "aws_route_table" "rt_3" {
  vpc_id                   = "${aws_vpc.vpc_1.id}"

  // TODO - route to NAT gateway

  route {
    cidr_block             = "10.2.0.0/16"
    gateway_id             = "${aws_vpc_peering_connection.pc_1.id}"
  }

  tags {
    Name                   = "${var.environment_name}_rt_2"
  }
}

# Route Table for Test Instance
resource "aws_route_table" "rt_4" {
  vpc_id                   = "${aws_vpc.vpc_2.id}"

  route {
    cidr_block             = "10.1.0.0/16"
    gateway_id             = "${aws_vpc_peering_connection.pc_1.id}"
  }

  tags {
    Name                   = "${var.environment_name}_rt_4"
  }
}

# Route Table for Bastion Instance
resource "aws_route_table" "rt_5" {
  vpc_id                   = "${aws_vpc.vpc_1.id}"

  route {
    cidr_block             = "0.0.0.0/0"
    gateway_id             = "${aws_internet_gateway.ig_1.id}"
  }

  route {
    cidr_block             = "10.2.0.0/16"
    gateway_id             = "${aws_vpc_peering_connection.pc_1.id}"
  }

  tags {
    Name                   = "${var.environment_name}_rt_5"
  }
}


################      Subnets      ################


# Subnet 1 in Availability Zone A for NAT gateway 1
resource "aws_subnet" "sn_1" {
  vpc_id                    = "${aws_vpc.vpc_1.id}"
  cidr_block                = "${var.aws_sn_1_cidr}"
  availability_zone         = "${var.aws_region}a"
  map_public_ip_on_launch   = true

  tags {
    Name                    = "${var.environment_name}_sn_1"
  }
}

# Subnet 2 in Availability Zone B for NAT gateway 1
resource "aws_subnet" "sn_2" {
  vpc_id                   = "${aws_vpc.vpc_1.id}"
  cidr_block               = "${var.aws_sn_2_cidr}"
  availability_zone        = "${var.aws_region}b"
  map_public_ip_on_launch  = true

  tags {
    Name                   = "${var.environment_name}_sn_2"
  }
}

# Subnet 3 in Availability Zone A for Squid Proxies
resource "aws_subnet" "sn_3" {
  vpc_id                   = "${aws_vpc.vpc_1.id}"
  cidr_block               = "${var.aws_sn_3_cidr}"
  availability_zone        = "${var.aws_region}a"
  map_public_ip_on_launch  = false

  tags {
    Name                   = "${var.environment_name}_sn_3"
  }
}

# Subnet 4 in Availability Zone B for Squid Proxies
resource "aws_subnet" "sn_4" {
  vpc_id                   = "${aws_vpc.vpc_1.id}"
  cidr_block               = "${var.aws_sn_4_cidr}"
  availability_zone        = "${var.aws_region}b"
  map_public_ip_on_launch  = false

  tags {
    Name                   = "${var.environment_name}_sn_4"
  }
}

# Subnet 5 in Availability Zone C for Bastion Hosts
resource "aws_subnet" "sn_5" {
  vpc_id                   = "${aws_vpc.vpc_1.id}"
  cidr_block               = "${var.aws_sn_5_cidr}"
  availability_zone        = "${var.aws_region}c"
  map_public_ip_on_launch  = true

  tags {
    Name                   = "${var.environment_name}_sn_5"
  }
}

# Subnet 6 in Availability Zone A for Test Hosts
resource "aws_subnet" "sn_6" {
  vpc_id                   = "${aws_vpc.vpc_2.id}"
  cidr_block               = "${var.aws_sn_6_cidr}"
  availability_zone        = "${var.aws_region}a"
  map_public_ip_on_launch  = false

  tags {
    Name                   = "${var.environment_name}_sn_6"
  }
}

# Subnet 7 in Availability Zone B for Test Hosts
resource "aws_subnet" "sn_6" {
  vpc_id                   = "${aws_vpc.vpc_2.id}"
  cidr_block               = "${var.aws_sn_7_cidr}"
  availability_zone        = "${var.aws_region}b"
  map_public_ip_on_launch  = false

  tags {
    Name                   = "${var.environment_name}_sn_7"
  }
}

## Red Zone Security Group (Load Balances)
#resource "aws_security_group" "red_sg" {
#  name        = "${var.environment_name}_red_sg"
#  vpc_id      = "${aws_vpc.vpc.id}"
#
#  # HTTP access from anywhere
#  ingress {
#    from_port   = 80
#    to_port     = 80
#    protocol    = "tcp"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  # HTTP access from Amber Zone
#  egress {
#    from_port   = 8080
#    to_port     = 8080
#    protocol    = "tcp"
#    cidr_blocks = ["${var.aws_amb_sn_az_a_cidr}", "${var.aws_amb_sn_az_b_cidr}"]
#  }
#
#  tags {
#    Name        = "${var.environment_name}_red_sg"
#  }
#}
#
## Amber Zone Subnet in Availability Zone A
#resource "aws_subnet" "amb_sn_az_a" {
#  vpc_id                  = "${aws_vpc.vpc.id}"
#  cidr_block              = "${var.aws_amb_sn_az_a_cidr}"
#  availability_zone       = "${var.aws_region}a"
#  map_public_ip_on_launch = true
#
#  tags {
#    Name                  = "${var.environment_name}_amb_sn_az_a"
#  }
#}
#
## Amber Zone Subnet in Availability Zone B
#resource "aws_subnet" "amb_sn_az_b" {
#  vpc_id                  = "${aws_vpc.vpc.id}"
#  cidr_block              = "${var.aws_amb_sn_az_b_cidr}"
#  availability_zone       = "${var.aws_region}b"
#  map_public_ip_on_launch = true
#
#  tags {
#    Name                  = "${var.environment_name}_amb_sn_az_b"
#  }
#}

## Amber Zone Security Group
#resource "aws_security_group" "amb_sg" {
#  name        = "${var.environment_name}_amb_sg"
#  vpc_id      = "${aws_vpc.vpc.id}"
#
#  # HTTP access from Red Zone
#  ingress {
#    from_port   = 8080
#    to_port     = 8080
#    protocol    = "tcp"
#    cidr_blocks = ["${var.aws_red_sn_az_a_cidr}", "${var.aws_red_sn_az_b_cidr}"]
#  }
#
#  # SSH access only from Bastion Network
#  ingress {
#    from_port   = 22
#    to_port     = 22
#    protocol    = "tcp"
#    cidr_blocks = ["${var.bastion_network_cidr}"]
#  }
#
#  # TODO: Remove outbound too all the world
#  egress {
#    from_port   = 0
#    to_port     = 0
#    protocol    = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
#  tags {
#    Name        = "${var.environment_name}_amb_sg"
#  }
#}
## Green Zone Subnet in Availability Zone A
#resource "aws_subnet" "grn_sn_az_a" {
#  vpc_id                  = "${aws_vpc.vpc.id}"
#  cidr_block              = "${var.aws_grn_sn_az_a_cidr}"
#  availability_zone       = "${var.aws_region}a"
#  map_public_ip_on_launch = false
#
#  tags {
#    Name                  = "${var.environment_name}_grn_sn_az_a"
#  }
#}
#
## Green Zone Subnet in Availability Zone B
#resource "aws_subnet" "grn_sn_az_b" {
#  vpc_id                  = "${aws_vpc.vpc.id}"
#  cidr_block              = "${var.aws_grn_sn_az_b_cidr}"
#  availability_zone       = "${var.aws_region}b"
#  map_public_ip_on_launch = false
#
#  tags {
#    Name                  = "${var.environment_name}_grn_sn_az_b"
#  }
#}
#
## Green Zone Security Group
#resource "aws_security_group" "grn_sg" {
#  name        = "${var.environment_name}_grn_sg"
#  vpc_id      = "${aws_vpc.vpc.id}"
#
#  # SSH access only from Bastion Network
#  ingress {
#    from_port   = 22
#    to_port     = 22
#    protocol    = "tcp"
#    cidr_blocks = ["${var.bastion_network_cidr}"]
#  }
#
#  # MySQL (Aurora) port access
#  ingress {
#    from_port   = 3306
#    to_port     = 3306
#    protocol    = "tcp"
#    cidr_blocks = ["${var.aws_amb_sn_az_a_cidr}", "${var.aws_amb_sn_az_b_cidr}"]
#  }
#
#  tags {
#    Name        = "${var.environment_name}_grn_sg"
#  }
#}
