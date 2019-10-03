module "s3_distribution_pr01" {
  source = "../../modules/s3_bucket"

  bucket_name     = "enphoto-pr01"
  access_identity = "EQH4KPLGLS6Q5"
  environment     = var.environment
  service_name    = var.service_name
  short_env       = var.short_env
}

module "s3_distribution_pr02" {
  source = "../../modules/s3_bucket"

  bucket_name     = "enphoto-pr02"
  access_identity = "EQH4KPLGLS6Q5"
  environment     = var.environment
  service_name    = var.service_name
  short_env       = var.short_env
}

module "s3_distribution_pr03" {
  source = "../../modules/s3_bucket"

  bucket_name     = "enphoto-pr03"
  access_identity = "EQH4KPLGLS6Q5"
  environment     = var.environment
  service_name    = var.service_name
  short_env       = var.short_env
}
