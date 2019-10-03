output "name" {
  value       = aws_s3_bucket.s3_bucket.id
  description = "S3 bucket name appear"
}

output "bucket_domain" {
  value       = aws_s3_bucket.s3_bucket.bucket_domain_name
  description = "The domain name of S3 bucket"
}
