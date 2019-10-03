resource "aws_s3_bucket" "s3_bucket" {
  bucket        = var.bucket_name
  region        = "ap-northeast-1"
  request_payer = "BucketOwner"

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "HEAD"]
    allowed_origins = ["*"]
    max_age_seconds = 3000
  }

  website {
      error_document = "error.html"
      index_document = "index.html"
  }

  tags = {
    Name        = "${var.service_name}-${var.short_env}-bucket"
    Environment = var.environment
    Service     = var.service_name
  }
}

data "template_file" "s3_bucket_policy" {
  template = file("${path.module}/template/bucket_policy.json.tpl")

  vars = {
    resource_bucket = var.bucket_name
    cdn_identity    = var.access_identity
  }
}

resource "aws_s3_bucket_policy" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy = data.template_file.s3_bucket_policy.rendered
}
