data "aws_iam_policy_document" "elasticsearch" {
  statement {
    actions = [
      "es:*",
    ]

    resources = [
      "${aws_elasticsearch_domain.service_es.arn}",
      "${aws_elasticsearch_domain.service_es.arn}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

resource "aws_elasticsearch_domain_policy" "elasticsearch" {
  domain_name     = aws_elasticsearch_domain.service_es.domain_name
  access_policies = data.aws_iam_policy_document.elasticsearch.json
}


resource "aws_elasticsearch_domain" "service_es" {
  domain_name           = "${var.service_name}-${var.short_env}-es-vpc"
  elasticsearch_version = "7.1"
  //  access_policies       = jsonencode(
  //    {
  //      Statement = [
  //        {
  //          Action    = "es:*"
  //          Effect    = "Allow"
  //          Principal = {
  //            AWS = "*"
  //          }
  //          Resource  = "arn:aws:es:ap-northeast-1:579663348364:domain/${var.es_domain}/*"
  //        },
  //      ]
  //      Version   = "2012-10-17"
  //    }
  //  )

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  cluster_config {
    instance_count = 1
    instance_type  = var.instance_type
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
    volume_type = "gp2"
  }

  vpc_options {
    security_group_ids = [var.default_sg]
    subnet_ids         = var.private_subnets
  }

  tags = {
    Name        = "${var.service_name}-${var.short_env}-es"
    Service     = var.service_name
    Environment = var.environment
  }
}

resource "aws_lb" "elasticsearch_alb" {
  name               = "${var.service_name}-${var.short_env}-es-alb"
  enable_http2       = true
  idle_timeout       = 60
  internal           = false
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.from_office.id]
  subnets            = var.public_subnets

  tags = {
    Name        = "${var.service_name}-${var.short_env}-alb"
    Service     = var.service_name
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "elasticsearch_target" {
  name                 = "${var.service_name}-${var.short_env}-es"
  deregistration_delay = 300
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = var.target_vpc

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 30
    matcher             = "200-399"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 3
  }

  stickiness {
    cookie_duration = 86400
    enabled         = false
    type            = "lb_cookie"
  }

  tags = {
    Name        = "${var.service_name}-${var.short_env}-es"
    Service     = var.service_name
    Environment = var.environment
  }
}

resource "aws_lb_listener" "elasticsearch_listner" {
  load_balancer_arn = aws_lb.elasticsearch_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.elasticsearch_target.arn
  }
}

resource "aws_lb_listener_rule" "kibana_listner_rules" {
  depends_on   = [aws_lb_listener.elasticsearch_listner]
  listener_arn = aws_lb_listener.elasticsearch_listner.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.elasticsearch_target.arn
  }

  condition {
    field = "path-pattern"
    values = [
      "/_plugin/kibana/*"
    ]
  }
}

resource "aws_lb_listener_rule" "kibana_app_listner_rules" {
  depends_on   = [aws_lb_listener.elasticsearch_listner]
  listener_arn = aws_lb_listener.elasticsearch_listner.arn
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.elasticsearch_target.arn
  }

  condition {
    field = "path-pattern"
    values = [
      "/_plugin/kibana/app/kibana/*"
    ]
  }
}


resource "aws_security_group" "from_office" {
  name        = "${var.service_name}-${var.short_env}-es"
  description = "Security group for ${var.environment} Elasticsearch"
  vpc_id      = var.target_vpc

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "default"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  ingress = [
    {
      cidr_blocks      = []
      description      = "from default sg"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      from_port        = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = [var.default_sg]
      self             = false
    },
    {
      cidr_blocks      = ["118.103.95.42/32"]
      description      = "from vpn"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      from_port        = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      cidr_blocks      = ["39.110.205.167/32"]
      description      = "from office wifi"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name        = "${var.service_name}-${var.short_env}-es"
    Service     = var.service_name
    Environment = var.environment
  }
}

resource "aws_vpc_endpoint" "log_sender_endpoint" {
  vpc_id              = var.target_vpc
  vpc_endpoint_type   = "Interface"
  service_name        = "com.amazonaws.ap-northeast-1.sns"
  private_dns_enabled = true
  policy = jsonencode(
    {
      Statement = [
        {
          Action    = "*"
          Effect    = "Allow"
          Principal = "*"
          Resource  = "*"
        },
      ]
    }
  )
  security_group_ids = [aws_security_group.from_office.id]
  subnet_ids         = var.public_subnets

  tags = {
    Name        = "${var.service_name}-${var.short_env}-es-endpoint"
    Service     = var.service_name
    Environment = var.environment
  }
}

resource "aws_cloudwatch_metric_alarm" "es_red_status" {
  alarm_name          = "${var.service_name}-elasticsearch ClusterStatusRed"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  namespace           = "AWS/ES"
  metric_name         = "ClusterStatus.red"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "1"
  treat_missing_data  = "notBreaching"

  dimensions {
    DomainName = aws_elasticsearch_domain.service_es.domain_name
  }
}

resource "aws_cloudwatch_metric_alarm" "es_yellow_status" {
  alarm_name          = "${var.service_name}-elasticsearch ClusterStatusYellow"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  namespace           = "AWS/ES"
  metric_name         = "ClusterStatus.yellow"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "1"
  treat_missing_data  = "notBreaching"

  dimensions {
    DomainName = aws_elasticsearch_domain.service_es.domain_name
  }
}

resource "aws_cloudwatch_metric_alarm" "es_free_storage" {
  alarm_name          = "${var.service_name}-elasticsearch FreeStorageSpace"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  namespace           = "AWS/ES"
  metric_name         = "FreeStorageSpace"
  period              = "60"
  statistic           = "Maximum"
  threshold           = (aws_elasticsearch_domain.service_es.ebs_options.0.volume_size * 1024) / 4
  treat_missing_data  = "notBreaching"

  dimensions {
    DomainName = aws_elasticsearch_domain.service_es.domain_name
  }
}
