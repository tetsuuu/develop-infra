module "s3_distribution_staging" {
  source = "../../modules/s3_bucket"

  bucket_name     = "enphoto-stg"
  access_identity = "EQH4KPLGLS6Q5"
}
