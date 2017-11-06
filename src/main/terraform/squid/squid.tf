# Specify the provider and access details
provider "aws" {
  region                       = "${var.aws_region}"
}

resource "aws_instance" "squid" {
  instance_type                = "${var.aws_instance_type}"
  ami                          = "${var.aws_ami}"
  key_name                     = "${var.aws_key_name}"
  vpc_security_group_ids       = ["${var.aws_security_group_id}"]
  subnet_id                    = "${var.aws_subnet_id}"
  associate_public_ip_address  = false


  # We run a remote provisioner on the instance after creating it.
  # In this case, we just install nginx and start it. By default,
  # this should be on port 80
#  provisioner "remote-exec" {
#    # The connection block tells our provisioner how to communicate with the resource (instance)
#    connection {
#      type = "ssh"
#      user = "ec2-user"
#      agent = "true"
#    }
#
#    inline = [
#      "sudo yum update -y",
#      "sudo yum install -y docker",
#      "sudo service docker start",
#      "sudo usermod -a -G docker ec2-user",
#      "sudo docker run -d ${var.docker_environment_variables} ${var.docker_published_ports} ${var.docker_image}"
#
#    ]
#  }

  tags {
    Name                       = "${var.environment_name}_squid_proxy"
  }
}
