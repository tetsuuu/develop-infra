resource "aws_s3_bucket" "dev_s3_bucket" {
  bucket        = var.bucket_name
  region        = "ap-northeast-1"
  request_payer = "BucketOwner"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }

  tags = {
    Name        = "${var.service_name}-${var.short_env}-bucket"
    Environment = "${var.environment}"
    Service     = "${var.service_name}"
  }
}

data "template_file" "dev_s3_bucket_policy" {
  template = file("${path.module}/template/bucket_policy.json.tpl")

  vars = {
    resource_bucket = var.bucket_name
  }
}

resource "aws_s3_bucket_policy" "dev_s3_bucket_policy" {
  bucket = aws_s3_bucket.dev_s3_bucket.id
  policy = data.template_file.dev_s3_bucket_policy.rendered
}
