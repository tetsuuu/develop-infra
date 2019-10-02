module "s3_distribution_pr01" {
  source = "../../modules/aws/cloudfront"

  environment        = var.environment
  service_name       = var.service_name
  short_env          = var.short_env
  origin_id          = "S3-enphoto-pr01/thumbnail"
  origin_path        = "/thumbnail"
  domin_aliases      = "pr01-image"
  bucket_domain_name = "enphoto-pr01.s3.amazonaws.com"
  access_identity    = "EQH4KPLGLS6Q5"
}

module "s3_distribution_pr02" {
  source = "../../modules/aws/cloudfront"

  environment        = var.environment
  service_name       = var.service_name
  short_env          = var.short_env
  origin_id          = "S3-enphoto-pr02/thumbnail"
  origin_path        = "/thumbnail"
  domin_aliases      = "pr02-image"
  bucket_domain_name = "enphoto-pr02.s3.amazonaws.com"
  access_identity    = "EQH4KPLGLS6Q5"
}

module "s3_distribution_pr03" {
  source = "../../modules/aws/cloudfront"

  environment        = var.environment
  service_name       = var.service_name
  short_env          = var.short_env
  origin_id          = "S3-enphoto-pr03/thumbnail"
  origin_path        = "/thumbnail"
  domin_aliases      = "pr03-image"
  bucket_domain_name = "enphoto-pr03.s3.amazonaws.com"
  access_identity    = "EQH4KPLGLS6Q5"
}
