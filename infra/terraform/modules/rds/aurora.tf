# Aurora Cluster
resource "aws_rds_cluster" "this" {
  count = var.use_aurora ? 1 : 0

  cluster_identifier = "${var.name}-cluster"
  engine             = var.engine
  engine_version     = var.engine_version

  master_username = var.username
  master_password = var.password
  database_name   = var.db_name

  db_subnet_group_name   = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  backup_retention_period = var.backup_retention_period

  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this[0].name

  # Skip final snapshot on deletion for Testing
  skip_final_snapshot = true
  tags = var.tags
}

# Writer/Reader instance
resource "aws_rds_cluster_instance" "this" {
  count = var.use_aurora ? var.aurora_instance_count : 0

  identifier = "${var.name}-${count.index == 0 ? "writer" : "reader-${count.index}"}"

  cluster_identifier = aws_rds_cluster.this[0].id
  instance_class     = var.instance_class
  engine             = var.engine

  publicly_accessible = var.publicly_accessible

  tags = var.tags
}

# Aurora parameter group
resource "aws_rds_cluster_parameter_group" "this" {
  count = var.use_aurora ? 1 : 0

  name   = "${var.name}-aurora-pg"
  family = var.parameter_group_family_aurora

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name         = parameter.key
      value        = parameter.value
      apply_method = "pending-reboot"
    }
  }

  tags = var.tags
}
