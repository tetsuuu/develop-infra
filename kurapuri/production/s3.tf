module "s3_distribution_production" {
  source = "../../modules/s3_bucket"

  bucket_name = "kurapuri-prod"
}
