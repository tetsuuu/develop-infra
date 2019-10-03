module "s3_distribution_production" {
  source = "../../modules/s3_bucket"

  bucket_name     = "kurapuri-prod"
  access_identity = "E3MM686S8EPFXT"
  environment     = var.environment
  service_name    = var.service_name
  short_env       = var.short_env
}
