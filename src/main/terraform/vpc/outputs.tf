output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "red_sn_az_a_id" {
  value = "${aws_subnet.red_sn_az_a.id}"
}

output "red_sn_az_b_id" {
  value = "${aws_subnet.red_sn_az_b.id}"
}

output "red_sg_id" {
  value = "${aws_security_group.red_sg.id}"
}

output "amb_sn_az_a_id" {
  value = "${aws_subnet.amb_sn_az_a.id}"
}

output "amb_sn_az_b_id" {
  value = "${aws_subnet.amb_sn_az_b.id}"
}

output "amb_sg_id" {
  value = "${aws_security_group.amb_sg.id}"
}

output "grn_sn_az_a_id" {
  value = "${aws_subnet.grn_sn_az_a.id}"
}

output "grn_sn_az_b_id" {
  value = "${aws_subnet.grn_sn_az_b.id}"
}

output "grn_sg_id" {
  value = "${aws_security_group.grn_sg.id}"
}
