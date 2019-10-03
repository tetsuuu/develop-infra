module "s3_distribution_thumbnail" {
  source = "../../modules/cloudfront"

  environment        = var.environment
  service_name       = var.service_name
  short_env          = var.short_env
  origin_id          = "S3-enphoto-prod/thumbnail"
  origin_path        = "/thumbnail"
  domin_aliases      = "image"
  bucket_domain_name = "enphoto-prod.s3.amazonaws.com"
  access_identity    = "EAKHBYYMLOWYU"
}
