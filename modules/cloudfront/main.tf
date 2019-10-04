resource "aws_cloudfront_distribution" "s3_image" {
  enabled             = true
  http_version        = "http2"
  is_ipv6_enabled     = true
  comment             = "${var.service_name} ${var.environment} thumbnail"
  aliases             = ["${var.domin_aliases}.${lookup(local.delegate_domain, var.service_name)}"]
  wait_for_deployment = true
  price_class         = "PriceClass_200"

  // customError 403
  custom_error_response {
    error_caching_min_ttl = 5
    error_code            = 403
    response_code         = 404
    response_page_path    = "/nophoto.png"
  }

  // customError 404
  custom_error_response {
    error_caching_min_ttl = 5
    error_code            = 404
    response_code         = 404
    response_page_path    = "/nophoto.png"
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = false
    default_ttl            = 60
    min_ttl                = 1
    max_ttl                = 31536000
    smooth_streaming       = false
    target_origin_id       = var.origin_id
    trusted_signers        = ["self"]
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }

    }
  }

  origin {
    domain_name = var.bucket_domain_name
    origin_id   = var.origin_id
    origin_path = var.origin_path

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/${var.access_identity}"
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = lookup(local.acm_arn, var.service_name)
    cloudfront_default_certificate = false
    iam_certificate_id             = ""
    minimum_protocol_version       = "TLSv1"
    ssl_support_method             = "sni-only"
  }

  tags = {
    Name        = "${var.service_name}-${var.short_env}-cloudfront"
    Environment = var.environment
    Service     = var.service_name
  }
}

data "aws_route53_zone" "root_zone" {
  name = "${lookup(local.delegate_domain, var.service_name)}."
}

resource "aws_route53_record" "s3_image" {
  depends_on = ["aws_cloudfront_distribution.s3_image"]
  zone_id = data.aws_route53_zone.root_zone.zone_id
  name    = var.domin_aliases
  type    = "CNAME"
  ttl     = "300"
  records = [aws_cloudfront_distribution.s3_image.domain_name]
}
