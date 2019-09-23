resource "aws_s3_bucket" "dev_s3_bucket" {
  count         = length(var.dev_s3_bucket.buckets)
  bucket        = "${var.service_name}-${var.short_env}-${values(var.dev_s3_bucket.buckets)[count.index].name}"
  region        = "ap-northeast-1"
  request_payer = "BucketOwner"
  policy        = file("./template/bucket_policy.json")

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
