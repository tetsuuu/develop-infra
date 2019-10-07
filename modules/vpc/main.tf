resource "aws_vpc" "service_vpc" {
  cidr_block           = lookup(local.vpc_cidr_blocks, default)
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
  count                   = length(split(",", lookup(local.availability_zones, default)))
  vpc_id                  = aws_vpc.service_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.service_vpc.cidr_block, 4, count.index + length(split(",", lookup(local.availability_zones, default))) * 0)
  availability_zone       = split(",", lookup(local.availability_zones, default))[count.index]
  map_public_ip_on_launch = true
  depends_on              = ["aws_vpc.service_vpc"]

  tags = {
    Name         = "${var.service_name}-${var.short_env}-public-${count.index}"
    Envvironment = var.environment
    Service      = var.service_name
  }
}

resource "aws_subnet" "private" {
  count                   = length(split(",", lookup(local.availability_zones, default)))
  vpc_id                  = aws_vpc.service_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.service_vpc.cidr_block, 4, count.index + length(split(",", lookup(local.availability_zones, default))) * 1)
  availability_zone       = split(",", lookup(local.availability_zones, default))[count.index]
  map_public_ip_on_launch = false
  depends_on              = ["aws_vpc.service_vpc"]

  tags = {
    Name         = "${var.service_name}-${var.short_env}-private-${count.index}"
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

resource "aws_route_table" "public" {
  count  = length(split(",", lookup(local.availability_zones, default)))
  vpc_id = aws_vpc.service_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name         = "${var.service_name}-${var.short_env}-route-public"
    Envvironment = var.environment
    Service      = var.service_name
  }
}

resource "aws_route_table" "private" {
  count  = length(split(",", lookup(local.availability_zones, default)))
  vpc_id = aws_vpc.service_vpc.id

  tags = {
    Name         = "${var.service_name}-${var.short_env}-route-private-${count.index}"
    Envvironment = var.environment
    Service      = var.service_name
  }
}

resource "aws_route_table_association" "public" {
  count          = length(split(",", lookup(local.availability_zones, default)))
  depends_on     = ["aws_route_table.public", "aws_subnet.public"]
  route_table_id = aws_route_table.public.*.id[count.index]
  subnet_id      = aws_subnet.public.*.id[count.index]
}

resource "aws_route_table_association" "private" {
  count          = length(split(",", lookup(local.availability_zones, default)))
  depends_on     = ["aws_route_table.private", "aws_subnet.private"]
  route_table_id = aws_route_table.private.*.id[count.index]
  subnet_id      = aws_subnet.private.*.id[count.index]
}

resource "aws_security_group" "default" {
  name        = "${var.service_name}-${var.short_env}-default"
  description = "${var.service_name}-${var.short_env}-default"
  vpc_id      = aws_vpc.service_vpc.id

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = var.maintenance_cidr_blocks
  }

  tags = {
    Name         = "${var.service_name}-${var.short_env}-admintools"
    Envvironment = var.environment
    Service      = var.service_name
  }
}

resource "aws_security_group_rule" "default" {
  depends_on        = ["aws_security_group.default"]
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  cidr_blocks       = var.maintenance_cidr_blocks
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group" "admintools" {
  count       = var.environment == "production" ? 1 : 0
  name        = "${var.service_name}-${var.short_env}-admintools"
  description = "${var.service_name}-${var.short_env}-admintools"
  vpc_id      = aws_vpc.service_vpc.id

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = var.maintenance_cidr_blocks
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
  security_group_id = aws_security_group.admintools.id
}

resource "aws_security_group" "adminer" {
  count       = var.environment == "staging || production" ? 1 : 0 //TODO
  name        = "${var.service_name}-${var.short_env}-adminer"
  description = "${var.service_name}-${var.short_env}-adminer"
  vpc_id      = aws_vpc.service_vpc.id

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["39.110.205.167/32"]
  }

  tags = {
    Name         = "${var.service_name}-${var.short_env}-adminer"
    Envvironment = var.environment
    Service      = var.service_name
  }
}

resource "aws_security_group_rule" "adminer_80_ingress" {
  count             = var.environment == "staging || production" ? 1 : 0 //TODO
  depends_on        = ["aws_security_group.adminer"]
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["118.103.95.42/32, 39.110.205.167/32, 114.160.214.15/32"]
  security_group_id = aws_security_group.adminer.id
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
