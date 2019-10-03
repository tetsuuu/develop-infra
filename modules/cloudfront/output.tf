output "cloudfront_domain" {
  value       = aws_cloudfront_distribution.s3_image.domain_name
  description = "The domain of Cloudfront origin for Route53"
}
