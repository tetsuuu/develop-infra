resource "aws_cloudfront_distribution" "s3_distribution_dev" {
  enabled                        = true
  aliases                        = ["dev-image.en-photo.net"]
  http_version                   = "http2"
  comment                        = "${var.service_name} ${var.environment} thumbnail"
  is_ipv6_enabled                = true
  price_class                    = "PriceClass_200"
  wait_for_deployment            = true

  // customError 403
  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 403
    response_code         = 403
    response_page_path    = "/nophoto.png"
  }

  // customError 404
  custom_error_response {
    error_caching_min_ttl = 300
    error_code            = 404
    response_code         = 404
    response_page_path    = "/nophoto.png"
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    compress               = false
    default_ttl            = 60
    max_ttl                = 31536000
    min_ttl                = 0
    smooth_streaming       = false
    target_origin_id       = "S3-enphoto-dev/thumbnail"
    trusted_signers        = ["self"]
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string  = false
      headers       = ["Origin"]

      cookies {
        forward  = "none"
      }
    }
  }

  ordered_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = false
    default_ttl            = 86400
    max_ttl                = 31536000
    min_ttl                = 0
    path_pattern           = "/exhibit/*"
    smooth_streaming       = false
    target_origin_id       = "S3-enphoto-dev/download/exhibit"
    viewer_protocol_policy = "allow-all"

    forwarded_values {
      query_string         = false

      cookies {
        forward  = "none"
      }
    }
  }

  origin {
    domain_name = "enphoto-dev.s3.amazonaws.com"
    origin_id   = "S3-enphoto-dev/download/exhibit"
    origin_path = "/download"

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/E3OIC1NJRUT25W"
    }
  }

  origin {
    domain_name = "enphoto-dev.s3.amazonaws.com"
    origin_id   = "S3-enphoto-dev/thumbnail"
    origin_path = "/thumbnail"

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/E3OIC1NJRUT25W"
    }
  }

  origin {
    domain_name = "enphoto-dev-doue.s3.amazonaws.com"
    origin_id   = "S3-enphoto-dev-doue/thumbnail"
    origin_path = "/thumbnail"

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/E3OIC1NJRUT25W"
    }
  }

  origin {
    domain_name = "enphoto-dev-yoshida.s3.amazonaws.com"
    origin_id   = "S3-enphoto-dev-yoshida/thumbnail"
    origin_path = "/thumbnail"

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/E3OIC1NJRUT25W"
    }
  }

  origin {
    domain_name = "enphoto-dev-noda.s3.amazonaws.com"
    origin_id   = "S3-enphoto-dev-noda/thumbnail"
    origin_path = "/thumbnail"

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/E3OIC1NJRUT25W"
    }
  }

  origin {
    domain_name = "enphoto-dev-suzuki.s3.amazonaws.com"
    origin_id   = "S3-enphoto-dev-suzuki/thumbnail"
    origin_path = "/thumbnail"

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/E3OIC1NJRUT25W"
    }
  }

  origin {
    domain_name = "enphoto-dev-ota.s3.amazonaws.com"
    origin_id   = "S3-enphoto-dev-ota/thumbnail"
    origin_path = "/thumbnail"

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/E3OIC1NJRUT25W"
    }
  }

  origin {
    domain_name = "enphoto-dev-ito.s3.amazonaws.com"
    origin_id   = "S3-enphoto-dev-ito/thumbnail"
    origin_path = "/thumbnail"

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/E3OIC1NJRUT25W"
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = "arn:aws:acm:us-east-1:579663348364:certificate/d117f281-073a-4663-ae6e-9f80e5869907"
    cloudfront_default_certificate = false
    minimum_protocol_version       = "TLSv1"
    ssl_support_method             = "sni-only"
  }

  tags = {
    Name        = "${var.service_name}-${var.short_env}-cloudfront"
    Environment = "${var.environment}"
    Service     = "${var.service_name}"
  }
}
