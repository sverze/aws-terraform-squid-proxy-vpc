# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}

################        VPC        ################


# Public VPC required for NAT gateways and Squid Proxies
resource "aws_vpc" "vpc_1" {
  cidr_block                   = "${var.aws_public_vpc_cidr}"
  enable_dns_support           = "true"
  enable_dns_hostnames         = "true"

  tags {
    Name                       = "${var.environment_name}_vpc_1"
  }
}

# Private VPC to launch our test instances into
resource "aws_vpc" "vpc_2" {
  cidr_block                   = "${var.aws_private_vpc_cidr}"
  enable_dns_support           = true
  enable_dns_hostnames         = true

  tags {
    Name                       = "${var.environment_name}_vpc_2"
  }
}

# Private VPC to launch our test instances into
resource "aws_vpc_peering_connection" "pc_1" {
  peer_vpc_id                  = "${aws_vpc.vpc_2.id}"
  vpc_id                       = "${aws_vpc.vpc_1.id}"
  auto_accept                  = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags {
    Name                       = "${var.environment_name}_pc_1"
  }
}


################ Internet Gateway  ################


# TODO - Consider changing to egresss only gateway
# Internet Gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "ig_1" {
  vpc_id                       = "${aws_vpc.vpc_1.id}"

  tags {
    Name                       = "${var.environment_name}_ig_1"
  }
}


################    NAT Gateways   ################


resource "aws_eip" "eip_1" {
  vpc      = true
}

# NAT Gateway for Availability Zone A
resource "aws_nat_gateway" "ng_1" {
  allocation_id                = "${aws_eip.eip_1.id}"
  subnet_id                    = "${aws_subnet.sn_1.id}"
}

resource "aws_eip" "eip_2" {
  vpc      = true
}

# NAT Gateway for Availability Zone B
resource "aws_nat_gateway" "ng_2" {
  allocation_id                = "${aws_eip.eip_2.id}"
  subnet_id                    = "${aws_subnet.sn_2.id}"
}


################   Route Tables    ################


# Route Table for Internet access
resource "aws_route_table" "rt_1" {
  vpc_id                       = "${aws_vpc.vpc_1.id}"

  route {
    cidr_block                 = "0.0.0.0/0"
    gateway_id                 = "${aws_internet_gateway.ig_1.id}"
  }

  tags {
    Name                       = "${var.environment_name}_rt_1"
  }
}

# Route Table for Squid 1 / NAT / PC
resource "aws_route_table" "rt_2" {
  vpc_id                       = "${aws_vpc.vpc_1.id}"

  route {
    cidr_block                 = "0.0.0.0/0"
    nat_gateway_id             = "${aws_nat_gateway.ng_1.id}"
  }

  route {
    cidr_block                 = "10.2.0.0/16"
    vpc_peering_connection_id  = "${aws_vpc_peering_connection.pc_1.id}"
  }

  tags {
    Name                       = "${var.environment_name}_rt_2"
  }
}

# Route Table for Squid 2 / NAT / PC
resource "aws_route_table" "rt_3" {
  vpc_id                   = "${aws_vpc.vpc_1.id}"

  route {
    cidr_block                 = "0.0.0.0/0"
    nat_gateway_id             = "${aws_nat_gateway.ng_1.id}"
  }

  route {
    cidr_block                 = "10.2.0.0/16"
    vpc_peering_connection_id  = "${aws_vpc_peering_connection.pc_1.id}"
  }

  tags {
    Name                       = "${var.environment_name}_rt_3"
  }
}

# Route Table for Test Instance
resource "aws_route_table" "rt_4" {
  vpc_id                       = "${aws_vpc.vpc_2.id}"

  route {
    cidr_block                 = "10.1.0.0/16"
    vpc_peering_connection_id  = "${aws_vpc_peering_connection.pc_1.id}"
  }

  tags {
    Name                       = "${var.environment_name}_rt_4"
  }
}

# Route Table for Bastion Instance
resource "aws_route_table" "rt_5" {
  vpc_id                       = "${aws_vpc.vpc_1.id}"

  route {
    cidr_block                 = "0.0.0.0/0"
    gateway_id                 = "${aws_internet_gateway.ig_1.id}"
  }

  route {
    cidr_block                 = "10.2.0.0/16"
    vpc_peering_connection_id  = "${aws_vpc_peering_connection.pc_1.id}"
  }

  tags {
    Name                       = "${var.environment_name}_rt_5"
  }
}


################      Subnets      ################


# Subnet 1 in Availability Zone A for NAT gateway 1
resource "aws_subnet" "sn_1" {
  vpc_id                       = "${aws_vpc.vpc_1.id}"
  cidr_block                   = "${var.aws_sn_1_cidr}"
  availability_zone            = "${var.aws_region}a"
  map_public_ip_on_launch      = true

  tags {
    Name                       = "${var.environment_name}_sn_1"
  }
}

resource "aws_route_table_association" "rta_1" {
  subnet_id                    = "${aws_subnet.sn_1.id}"
  route_table_id               = "${aws_route_table.rt_1.id}"
}

# Subnet 2 in Availability Zone B for NAT gateway 2
resource "aws_subnet" "sn_2" {
  vpc_id                       = "${aws_vpc.vpc_1.id}"
  cidr_block                   = "${var.aws_sn_2_cidr}"
  availability_zone            = "${var.aws_region}b"
  map_public_ip_on_launch      = true

  tags {
    Name                       = "${var.environment_name}_sn_2"
  }
}

resource "aws_route_table_association" "rta_2" {
  subnet_id                    = "${aws_subnet.sn_2.id}"
  route_table_id               = "${aws_route_table.rt_1.id}"
}

# Subnet 3 in Availability Zone A for Squid Proxies
resource "aws_subnet" "sn_3" {
  vpc_id                       = "${aws_vpc.vpc_1.id}"
  cidr_block                   = "${var.aws_sn_3_cidr}"
  availability_zone            = "${var.aws_region}a"
  map_public_ip_on_launch      = false

  tags {
    Name                       = "${var.environment_name}_sn_3"
  }
}

resource "aws_route_table_association" "rta_3" {
  subnet_id                    = "${aws_subnet.sn_3.id}"
  route_table_id               = "${aws_route_table.rt_2.id}"
}

# Subnet 4 in Availability Zone B for Squid Proxies
resource "aws_subnet" "sn_4" {
  vpc_id                       = "${aws_vpc.vpc_1.id}"
  cidr_block                   = "${var.aws_sn_4_cidr}"
  availability_zone            = "${var.aws_region}b"
  map_public_ip_on_launch      = false

  tags {
    Name                       = "${var.environment_name}_sn_4"
  }
}

resource "aws_route_table_association" "rta_4" {
  subnet_id                    = "${aws_subnet.sn_4.id}"
  route_table_id               = "${aws_route_table.rt_3.id}"
}

# Subnet 5 in Availability Zone C for Bastion Hosts
resource "aws_subnet" "sn_5" {
  vpc_id                       = "${aws_vpc.vpc_1.id}"
  cidr_block                   = "${var.aws_sn_5_cidr}"
  availability_zone            = "${var.aws_region}c"
  map_public_ip_on_launch      = true

  tags {
    Name                       = "${var.environment_name}_sn_5"
  }
}

resource "aws_route_table_association" "rta_5" {
  subnet_id                    = "${aws_subnet.sn_5.id}"
  route_table_id               = "${aws_route_table.rt_5.id}"
}

# Subnet 6 in Availability Zone A for Application Test Hosts
resource "aws_subnet" "sn_6" {
  vpc_id                       = "${aws_vpc.vpc_2.id}"
  cidr_block                   = "${var.aws_sn_6_cidr}"
  availability_zone            = "${var.aws_region}a"
  map_public_ip_on_launch      = false

  tags {
    Name                       = "${var.environment_name}_sn_6"
  }
}

resource "aws_route_table_association" "rta_6" {
  subnet_id                    = "${aws_subnet.sn_6.id}"
  route_table_id               = "${aws_route_table.rt_4.id}"
}

# Subnet 7 in Availability Zone B for Application Test Hosts
resource "aws_subnet" "sn_7" {
  vpc_id                       = "${aws_vpc.vpc_2.id}"
  cidr_block                   = "${var.aws_sn_7_cidr}"
  availability_zone            = "${var.aws_region}b"
  map_public_ip_on_launch      = false

  tags {
    Name                       = "${var.environment_name}_sn_7"
  }
}

resource "aws_route_table_association" "rta_7" {
  subnet_id                    = "${aws_subnet.sn_7.id}"
  route_table_id               = "${aws_route_table.rt_4.id}"
}


################  Security Groups  ################


# Security Group for Bastion Hosts
resource "aws_security_group" "sg_1" {
  name                         = "${var.environment_name}_sg_1"
  vpc_id                       = "${aws_vpc.vpc_1.id}"

  # SSH access only from Bastion network
  ingress {
    from_port                  = 22
    to_port                    = 22
    protocol                   = "tcp"
    cidr_blocks                = ["${var.bastion_network_cidr}"]
  }

  egress {
    from_port                  = 0
    to_port                    = 0
    protocol                   = "-1"
    cidr_blocks                = ["0.0.0.0/0"]
  }

  tags {
    Name                       = "${var.environment_name}_sg_1"
  }
}

# Security Group for Test Hosts
resource "aws_security_group" "sg_2" {
  name                         = "${var.environment_name}_sg_1"
  vpc_id                       = "${aws_vpc.vpc_2.id}"

  # SSH access from Bastion security group
  ingress {
    from_port                  = 22
    to_port                    = 22
    protocol                   = "tcp"
    security_groups            = ["${aws_security_group.sg_1.id}"]
  }

  egress {
    from_port                  = 0
    to_port                    = 0
    protocol                   = "-1"
    cidr_blocks                = ["0.0.0.0/0"]
  }

  tags {
    Name                       = "${var.environment_name}_sg_2"
  }
}

# Security Group for Squid Proxies
resource "aws_security_group" "sg_3" {
  name                         = "${var.environment_name}_sg_3"
  vpc_id                       = "${aws_vpc.vpc_1.id}"

  # SSH access from Bastion security group
  ingress {
    from_port                  = 22
    to_port                    = 22
    protocol                   = "tcp"
    security_groups            = ["${aws_security_group.sg_1.id}"]
  }

  # Squid proxy port
  ingress {
    from_port                  = 3128
    to_port                    = 3128
    protocol                   = "tcp"
    self                       = true
    security_groups            = ["${aws_security_group.sg_2.id}"]
  }

  egress {
    from_port                  = 0
    to_port                    = 0
    protocol                   = "-1"
    cidr_blocks                = ["0.0.0.0/0"]
  }

  tags {
    Name                       = "${var.environment_name}_sg_3"
  }
}