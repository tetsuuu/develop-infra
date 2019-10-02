resource "aws_cloudwatch_event_rule" "start-stepfunctions" {
  name        = "spica_stepfunctions_${var.short_env}"
  description = "Kick stepFunctions by S3 Object for ${var.environment} Spica"

  event_pattern = <<PATTERN
{
  "detail": {
    "eventName": [
      "PutObject"
    ],
    "eventSource": [
      "s3.amazonaws.com"
    ],
    "requestParameters": {
      "bucketName": [
        "enphoto-stg"
      ]
    }
  },
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "source": [
    "aws.s3"
  ]
}
PATTERN

  tags = {
    Name        = "${var.service_name}-${var.short_env}-cw-events"
    Environment = "${var.environment}"
    Service     = "${var.service_name}"
  }
}

resource "aws_iam_role" "start-stepfunctions" {
  name        = "cwevent_spica_stepfunctions_${var.short_env}"
  description = "Kick stepFunctions by S3 Object for ${var.environment} Spica"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = {
    Name        = "${var.service_name}-${var.short_env}-role"
    Environment = "${var.environment}"
    Service     = "${var.service_name}"
  }
}

resource "aws_iam_policy" "start-stepfunctions" {
  name        = "cwEventSpicaStepfunctions_${var.short_env}"
  path        = "/service-role/"
  description = "Kick stepFunctions by S3 Object for ${var.environment} Spica"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "states:StartExecution"
      ],
      "Resource": [
        "arn:aws:states:ap-northeast-1:579663348364:stateMachine:*"
      ]
    }
  ]
}
EOF

  tags = {
    Name        = "${var.service_name}-${var.short_env}"
    Environment = "${var.environment}"
    Service     = "${var.service_name}"
  }
}

resource "aws_iam_policy_attachment" "start-stepfunctions" {
  name       = "cwEventSpicaStepfunctions_${var.short_env}"
  policy_arn = "${aws_iam_policy.start-stepfunctions.arn}"
}

resource "aws_cloudtrail" "s3-objects" {
  name                          = "tf-trail-foobar"
  s3_bucket_name                = "enphoto-stg-cloudtail-logs" //TODO
  include_global_service_events = true
  enable_logging                = true
  enable_log_file_validation    = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::enphoto-stg/serverless-test/"] //TODO confirm
    }
  }

  tags = {
    Name        = "${var.service_name}-${var.short_env}"
    Environment = "${var.environment}"
    Service     = "${var.service_name}"
  }
}

