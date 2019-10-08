resource "aws_vpc" "service_vpc" {
  cidr_block           = lookup(local.vpc_cidr_blocks, "default")
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name         = "${var.service_name}-${var.short_env}-vpc"
    Envvironment = var.environment
    Service      = var.service_name
  }
}

resource "aws_subnet" "public" {
  count                   = length(split(",", lookup(local.availability_zones, "default")))
  vpc_id                  = aws_vpc.service_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.service_vpc.cidr_block, 4, count.index + length(split(",", lookup(local.availability_zones, "default"))) * 0)
  availability_zone       = split(",", lookup(local.availability_zones, "default"))[count.index]
  map_public_ip_on_launch = true
  depends_on              = ["aws_vpc.service_vpc"]

  tags = {
    Name         = "${var.service_name}-${var.short_env}-sub-public-${count.index}"
    Envvironment = var.environment
    Service      = var.service_name
  }
}

resource "aws_subnet" "private" {
  count                   = length(split(",", lookup(local.availability_zones, "default")))
  vpc_id                  = aws_vpc.service_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.service_vpc.cidr_block, 4, count.index + length(split(",", lookup(local.availability_zones, "default"))) * 1)
  availability_zone       = split(",", lookup(local.availability_zones, "default"))[count.index]
  map_public_ip_on_launch = false
  depends_on              = ["aws_vpc.service_vpc"]

  tags = {
    Name         = "${var.service_name}-${var.short_env}-sub-private-${count.index}"
    Envvironment = var.environment
    Service      = var.service_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.service_vpc.id

  tags = {
    Name         = "${var.service_name}-${var.short_env}-igw"
    Envvironment = var.environment
    Service      = var.service_name
  }
}

resource "aws_route_table" "default" {
  vpc_id = aws_vpc.service_vpc.id

  tags = {
    Name         = "${var.service_name}-${var.short_env}-default"
    Envvironment = var.environment
    Service      = var.service_name
  }
}

resource "aws_route" "default" {
  route_table_id         = aws_route_table.default.id
  destination_cidr_block = "172.31.0.0/16"
  gateway_id             = "local"
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.service_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name         = "${var.service_name}-${var.short_env}-public"
    Envvironment = var.environment
    Service      = var.service_name
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.service_vpc.id

  tags = {
    Name         = "${var.service_name}-${var.short_env}-private"
    Envvironment = var.environment
    Service      = var.service_name
  }
}

resource "aws_vpc_endpoint" "s3" {
  depends_on      = ["aws_route_table.private"]
  vpc_id          = aws_vpc.service_vpc.id
  service_name    = "com.amazonaws.ap-northeast-1.s3"
  route_table_ids = [aws_route_table.private.id]

  tags = {
    Name         = "${var.service_name}-${var.short_env}-s3-endpoint"
    Envvironment = var.environment
    Service      = var.service_name
  }
}

resource "aws_route_table_association" "public" {
  count          = length(split(",", lookup(local.availability_zones, "default")))
  depends_on     = ["aws_route_table.public", "aws_subnet.public"]
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public.*.id[count.index]
}

resource "aws_route_table_association" "private" {
  count          = length(split(",", lookup(local.availability_zones, "default")))
  depends_on     = ["aws_route_table.private", "aws_subnet.private"]
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private.*.id[count.index]
}

resource "aws_security_group" "default" {
  name        = "default"
  description = "default VPC security group"
  vpc_id      = aws_vpc.service_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress     = [
    {
      cidr_blocks      = []
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = true
      to_port          = 0
    },
    {
      cidr_blocks      = [aws_vpc.service_vpc.cidr_block]
      description      = ""
      from_port        = 3306
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 3306
    },
    {
      cidr_blocks      = [aws_vpc.service_vpc.cidr_block]
      description      = ""
      from_port        = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 80
    }
  ]

  tags = {
    Name         = "${var.service_name}-${var.short_env}-default"
    Envvironment = var.environment
    Service      = var.service_name
  }
}


//resource "aws_security_group_rule" "default-3" {
//  depends_on        = ["aws_security_group.default"]
//  type              = "ingress"
//  from_port         = 80
//  to_port           = 80
//  protocol          = "tcp"
//  cidr_blocks       = [aws_vpc.service_vpc.cidr_block]
//  security_group_id = aws_security_group.default.id
//}

resource "aws_security_group" "admintools" {
  count       = var.environment == "production" ? 1 : 0
  name        = "${var.service_name}-${var.short_env}-admintools"
  description = "${var.service_name}-${var.short_env}-admintools"
  vpc_id      = aws_vpc.service_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.maintenance_cidr_blocks
  }

  tags = {
    Name         = "${var.service_name}-${var.short_env}-admintools"
    Envvironment = var.environment
    Service      = var.service_name
  }
}

resource "aws_security_group_rule" "admintools_443_ingress" {
  count             = var.environment == "production" ? 1 : 0
  depends_on        = ["aws_security_group.admintools"]
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.maintenance_cidr_blocks
  security_group_id = aws_security_group.admintools[count.index]
}

/* TODO arrenge later
resource "aws_flow_log" "vpc-flow-log" {
  count                = "${var.environment == "production" ? 1 : 0}"
  depends_on           = ["aws_cloudwatch_log_group.vpc-flow-log-group", "aws_iam_role_policy_attachment.put-vpc-flow-log-policy-attach"]
  log_destination_type = "cloud-watch-logs"
  log_destination      = "${aws_cloudwatch_log_group.vpc-flow-log-group.arn}"
  iam_role_arn         = "${aws_iam_role.vpc-flow-log-role.arn}"
  vpc_id               = "${aws_vpc.service-vpc.id}"
  traffic_type         = "ALL"
}

resource "aws_cloudwatch_log_group" "vpc-flow-log-group" {
  count = "${var.environment == "production" ? 1 : 0}"
  name  = "${var.service_name}-${var.environment}-vpc-flow-log"
}

resource "aws_iam_role" "vpc-flow-log-role" {
  count = "${var.environment == "production" ? 1 : 0}"
  name  = ""${var.service_name}-${var.environment}-vpc-flow-log-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_policy" "put-vpc-flow-log-policy" {
  count = "${var.environment == "production" ? 1 : 0}"
  name  = "${var.service_name}-${var.environment}-vpc-flow-log-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "put-vpc-flow-log-policy-attach" {
  count      = "${var.environment == "production" ? 1 : 0}"
  depends_on = ["aws_iam_role.vpc-flow-log-role", "aws_iam_policy.put-vpc-flow-log-policy"]
  role       = "${aws_iam_role.vpc-flow-log-role.name}"
  policy_arn = "${aws_iam_policy.put-vpc-flow-log-policy.arn}"
}
*/
