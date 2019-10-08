resource "aws_db_instance" "service_db" {
  identifier                      = var.db_identifier
  allocated_storage               = var.storage
  max_allocated_storage           = var.max_storage
  storage_type                    = "gp2"
  engine                          = var.engine
  engine_version                  = var.engine_version
  instance_class                  = var.instance_class
  name                            = var.name
  username                        = var.user
  password                        = var.password
  db_subnet_group_name            = aws_db_subnet_group.service_db.name
  publicly_accessible             = var.environment == "develop" ? true : false
  port                            = 3306
  parameter_group_name            = lookup(local.parameter_group, var.service_name)
  option_group_name               = lookup(local.option_group, var.service_name)
  backup_retention_period         = 7
  backup_window                   = var.backup_window
  maintenance_window              = var.maintenance_window
  deletion_protection             = var.environment == "production || staging" ? true : false
  skip_final_snapshot             = var.environment == "production || staging" ? true : false
  auto_minor_version_upgrade      = false
  apply_immediately               = true
  vpc_security_group_ids          = [aws_security_group.service_db.id]
  enabled_cloudwatch_logs_exports = lookup(local.log_level, var.service_name)
  //performance_insights_enabled = true

  tags = {
    Name        = "${var.service_name}-${var.short_env}-rds"
    Environment = var.environment
    Service     = var.service_name
  }
}

resource "aws_db_subnet_group" "service_db" {
  name        = var.db_subnet_group
  description = "${var.service_name} db subnet for ${var.environment}"
  subnet_ids  = var.private_sub

  tags = {
    Name         = "${var.service_name}-${var.environment}"
    Envvironment = var.environment
    Service      = var.service_name
  }
}

resource "aws_security_group" "service_db" {
  vpc_id      = var.target_vpc
  name        = "${var.service_name}-${var.short_env}-rds"
  description = var.sg_description

  ingress {
    protocol    = "tcp"
    from_port   = 3306
    to_port     = 3306
    self        = true
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.service_name}-${var.short_env}-rds"
    Environment = var.environment
    Service     = var.service_name
  }
}

// ingress from local for develop
resource "aws_security_group_rule" "developer" {
  count             = var.environment == "develop" ? 1 : 0
  depends_on        = ["aws_security_group.service_db"]
  description       = "Local access allow for ${var.service_name} ${var.environment} developer"
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = lookup(local.developers_ips, "default")
  security_group_id = aws_security_group.service_db.id
}
