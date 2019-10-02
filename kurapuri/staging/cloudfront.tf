module "s3_distribution_thumbnail" {
  source = "../../modules/aws/cloudfront"

  environment         = var.environment
  service_name        = var.service_name
  short_env           = var.short_env
  origin_id           = "S3-kurapuri-stg/thumbnail"
  origin_path         = "/thumbnail"
  domin_aliases       = "staging-image"
  bucket_domain_name  = "kurapuri-stg.s3.amazonaws.com"
  access_identity     = "E1LVSJ66E8RSWA"
}
