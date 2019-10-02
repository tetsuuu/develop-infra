resource "aws_sqs_queue" "default" {
  depends_on                        = ["aws_sqs_queue.download_queue"]
  name                              = "${var.service_name}-${var.short_env}"
  visibility_timeout_seconds        = 600
  redrive_policy                    = jsonencode(
  {
    deadLetterTargetArn = aws_sqs_queue.download_queue.arn
    maxReceiveCount     = 1000
  }
  )

  tags = {
    Name        = "${var.service_name}-${var.short_env}-sqs"
    Environment = var.environment
    Service     = var.service_name
  }
}

resource "aws_sqs_queue" "download_queue" {
  name                              = "${var.service_name}-${var.short_env}-dlq"
  visibility_timeout_seconds        = 600

  tags = {
    Name        = "${var.service_name}-${var.short_env}-sqs"
    Environment = var.environment
    Service     = var.service_name
  }
}

resource "aws_sqs_queue" "high_priority" {
  depends_on                        = ["aws_sqs_queue.download_queue_high_priority"]
  name                              = "${var.service_name}-${var.short_env}-high"
  visibility_timeout_seconds        = 600
  redrive_policy                    = jsonencode(
  {
    deadLetterTargetArn = aws_sqs_queue.download_queue_high_priority.arn
    maxReceiveCount     = 1000
  }
  )

  tags = {
    Name        = "${var.service_name}-${var.short_env}-sqs"
    Environment = var.environment
    Service     = var.service_name
  }
}

resource "aws_sqs_queue" "download_queue_high_priority" {
  name                              = "${var.service_name}-${var.short_env}-high-dlq"
  visibility_timeout_seconds        = 600

  tags = {
    Name        = "${var.service_name}-${var.short_env}-sqs"
    Environment = var.environment
    Service     = var.service_name
  }
}

resource "aws_sqs_queue" "low_priority" {
  name                              = "${var.service_name}-${var.short_env}-low"
  visibility_timeout_seconds        = 600
  redrive_policy                    = jsonencode(
  {
    deadLetterTargetArn = aws_sqs_queue.download_queue_low_priority.arn
    maxReceiveCount     = 1000
  }
  )

  tags = {
    Name        = "${var.service_name}-${var.short_env}-sqs"
    Environment = var.environment
    Service     = var.service_name
  }
}

resource "aws_sqs_queue" "download_queue_low_priority" {
  name                              = "${var.service_name}-${var.short_env}-low-dlq"
  visibility_timeout_seconds        = 600

  tags = {
    Name        = "${var.service_name}-${var.short_env}-sqs"
    Environment = var.environment
    Service     = var.service_name
  }
}
