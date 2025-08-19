data "aws_secretsmanager_secret_version" "rds_secret" {
  secret_id = "nimbus-postgres-secret"
}

locals {
  parsed_secret = jsondecode(data.aws_secretsmanager_secret_version.rds_secret.secret_string)
  rds_password = local.parsed_secret[var.db_username]
}

