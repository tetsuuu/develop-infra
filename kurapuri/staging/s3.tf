module "s3_distribution_staging" {
  source = "../../modules/s3_bucket"

  bucket_name     = "kurapuri-stg"
  access_identity = "E1LVSJ66E8RSWA"
  environment     = var.environment
  service_name    = var.service_name
  short_env       = var.short_env
}
