module "s3_distribution_production" {
  source = "../../modules/s3_bucket"

  bucket_name     = "enphoto-prod"
  access_identity = "EAKHBYYMLOWYU"
  environment     = var.environment
  service_name    = var.service_name
  short_env       = var.short_env
}
