output "rds_name" {
  value = var.name
}

output "rds_db_name" {
  value = var.db_name
}

output "rds_host" {
  value = var.use_aurora ? aws_rds_cluster.this[0].endpoint : aws_db_instance.this[0].address
}

output "rds_reader_endpoint" {
  value = var.use_aurora ? aws_rds_cluster.this[0].reader_endpoint : null
}

output "rds_port" {
  value = var.use_aurora ? aws_rds_cluster.this[0].port : aws_db_instance.this[0].port
}

output "rds_engine" {
  value = coalesce(
    try(aws_rds_cluster.this[0].engine, null),
    try(aws_db_instance.this[0].engine, null)
  )
}

output "rds_instance_identifier" {
  value = var.use_aurora ? aws_rds_cluster.this[0].cluster_identifier : aws_db_instance.this[0].identifier
}

output "rds_subnet_group_name" {
  value = aws_db_subnet_group.default.name
}

output "rds_security_group_id" {
  value = aws_security_group.rds.id
}

output "rds_username" {
  description = "The username for the RDS instance"
  value = var.username
}