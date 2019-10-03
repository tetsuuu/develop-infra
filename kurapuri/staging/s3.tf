module "s3_distribution_staging" {
  source = "../../modules/s3_bucket"

  bucket_name = "kurapuri-stg"
}
