
output "instance_id" {
  value = "${aws_instance.squid.id}"
}


output "squid_proxy_uri" {
  // TODO - get the ELB URI
  value = "${aws_instance.squid.id}"
}

output "squid_proxy_port" {
  // TODO - get the ELB Port
  value = "${aws_instance.squid.id}"
}

