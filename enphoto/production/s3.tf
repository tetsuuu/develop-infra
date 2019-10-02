module "s3_distribution_production" {
  source = "../../modules/aws/s3_bucket"

  bucket_name = "enphoto-prod"
}
