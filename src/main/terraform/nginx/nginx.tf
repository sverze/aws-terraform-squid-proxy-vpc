# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}

resource "aws_instance" "nginx" {
  instance_type = "t2.medium"

  # Lookup the correct AMI based on the region
  # we specified
  ami = "${lookup(var.aws_amis, var.aws_region)}"

  # The name of our SSH keypair we created above.
  key_name = "${var.aws_key_name}"

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = ["${var.aws_security_group_id}"]

  # We're going to launch into the same subnet as our ELB. In a production
  # environment it's more common to have a separate private subnet for
  # backend instances.
  subnet_id = "${var.aws_subnet_id}"

  # We run a remote provisioner on the instance after creating it.
  # In this case, we just install nginx and start it. By default,
  # this should be on port 80
  provisioner "remote-exec" {
    # The connection block tells our provisioner how to communicate with the resource (instance)
    connection {
      type = "ssh"
      user = "ubuntu"
      agent = "true"
    }

    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx",
      "sudo service nginx start"
    ]
  }
}
