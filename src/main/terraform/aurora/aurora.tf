resource "aws_rds_cluster" "aurora_rds_cluster" {
    cluster_identifier            = "${var.environment_name}-aurora-cluster"
    database_name                 = "${var.rds_database_name}"
    master_username               = "${var.rds_master_username}"
    master_password               = "${var.rds_master_password}"
    backup_retention_period       = 14
    preferred_backup_window       = "02:00-03:00"
    preferred_maintenance_window  = "wed:03:00-wed:04:00"
    db_subnet_group_name          = "${aws_db_subnet_group.aurora_subnet_group.name}"
    skip_final_snapshot           = true
    vpc_security_group_ids        = ["${var.vpc_rds_security_group_id}"]

    tags {
        Name         = "${var.environment_name}-Aurora-DB-Cluster"
        ManagedBy    = "terraform"
        Environment  = "${var.environment_name}"
    }

    lifecycle {
        create_before_destroy = true
    }

}

resource "aws_rds_cluster_instance" "aurora_cluster_instance" {
    count                 = "${var.rds_cluster_instance_count}"

    identifier            = "${var.environment_name}-aurora-instance-${count.index}"
    cluster_identifier    = "${aws_rds_cluster.aurora_rds_cluster.id}"
    instance_class        = "db.t2.small"
    db_subnet_group_name  = "${aws_db_subnet_group.aurora_subnet_group.name}"
    publicly_accessible   = false

    tags {
        Name         = "${var.environment_name}-Aurora-DB-Instance-${count.index}"
        ManagedBy    = "terraform"
        Environment  = "${var.environment_name}"
    }

    lifecycle {
        create_before_destroy = true
    }

}

resource "aws_db_subnet_group" "aurora_subnet_group" {
    name          = "${var.environment_name}_aurora_db_subnet_group"
    description   = "Allowed subnets for Aurora DB cluster instances"
    subnet_ids    = ["${var.vpc_rds_subnet_ids}"]

    tags {
        Name         = "${var.environment_name}-Aurora-DB-Subnet-Group"
        ManagedBy    = "terraform"
        Environment  = "${var.environment_name}"
    }
}

resource "null_resource" "dummy_dependency" {
    depends_on = ["aws_rds_cluster_instance.aurora_cluster_instance"]
}
