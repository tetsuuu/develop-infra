resource "aws_elasticache_cluster" "redis" {
  cluster_id           = var.cluster_name
  engine               = "redis"
  node_type            = var.node_type
  num_cache_nodes      = 1
  security_group_ids   = ["${aws_security_group.redis.id}"]
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.4"
  port                 = 6379

  tags = {
    Name        = "${var.service_name}-${var.short_env}-redis"
    Environment = "${var.environment}"
    Service     = "${var.service_name}"
  }
}

resource "aws_security_group" "redis" {
  name        = "${var.service_name}-${var.short_env}-redis"
  description = "Security group for ${var.service_name} ${var.environment} redis"
  vpc_id      = var.target_vpc

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["172.31.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.service_name}-${var.short_env}-redis-sg"
    Environment = "${var.environment}"
    Service     = "${var.service_name}"
  }
}

resource "aws_elasticache_subnet_group" "redis" {
  name       = "${var.service_name}-${var.short_env}-redis"
  subnet_ids = var.private_subnets
}
