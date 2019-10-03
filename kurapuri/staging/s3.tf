module "s3_distribution_staging" {
  source = "../../modules/s3_bucket"

  bucket_name     = "kurapuri-stg"
  access_identity = "E1LVSJ66E8RSWA"
}
