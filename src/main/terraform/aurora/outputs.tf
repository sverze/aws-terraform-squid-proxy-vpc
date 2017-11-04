output "cluster_endpoint" {
    value = "${aws_rds_cluster.aurora_rds_cluster.endpoint}"
}

output "cluster_port" {
    value = "${aws_rds_cluster.aurora_rds_cluster.port}"
}

output "depends_id" {
    value = "${null_resource.dummy_dependency.id}"
}
