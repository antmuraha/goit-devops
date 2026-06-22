resource "aws_secretsmanager_secret" "rds" {
  name = "fp-rds-secret"
}

resource "aws_secretsmanager_secret_version" "rds" {
  secret_id = aws_secretsmanager_secret.rds.id

  secret_string = jsonencode({
    host     = var.use_aurora ? aws_rds_cluster.this[0].endpoint : aws_db_instance.this[0].address
    port     = 5432
    dbname   = var.db_name
    username = var.username
    password = local.rds_secret.password
  })
}

data "aws_secretsmanager_secret_version" "rds" {
  secret_id = aws_db_instance.this[0].master_user_secret[0].secret_arn
}

locals {
  rds_secret = jsondecode(data.aws_secretsmanager_secret_version.rds.secret_string)
}

# resource "random_password" "rds" {
#   length  = 24
#   special = false

#   # override_special = "!#$%&*()-_=+[]{}<>?"
# }