resource "aws_security_group" "postgres" {
  name   = ""
  vpc_id = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Allow Postgres from EKS nodes
resource "aws_security_group_rule" "db_from_nodes" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.postgres.id
  source_security_group_id = var.eks_node_sg_id
}

resource "aws_db_subnet_group" "pg" {
  name       = "nimbus-pg-subnets"
  subnet_ids = var.private_subnet_ids
  tags       = var.tags
}


resource "aws_db_parameter_group" "pg" {
  name   = "nimbus-pg-params"
  family = "postgres16"
  tags   = var.tags
}



resource "aws_db_instance" "nimbus-db" {
  identifier              = "nimbusdb"
  engine                  = "postgres"
  engine_version          = "16.3"
  instance_class          = var.db_instance_class
  username                = var.db_username
  password                = local.rds_password
  db_subnet_group_name    = aws_db_subnet_group.pg.name
  multi_az                = true
  allocated_storage       = 50
  max_allocated_storage   = 200
  storage_encrypted       = true
  vpc_security_group_ids  = [aws_security_group.postgres.id]
  parameter_group_name    = aws_db_parameter_group.pg.name
  deletion_protection     = true
  skip_final_snapshot     = true
  publicly_accessible     = false
  backup_retention_period = 7
  tags                    = merge(var.tags, { Name = "NimbusDB" })
  depends_on              = [aws_security_group.postgres, aws_security_group_rule.db_from_nodes, aws_db_subnet_group.pg, aws_db_parameter_group.pg]
}
