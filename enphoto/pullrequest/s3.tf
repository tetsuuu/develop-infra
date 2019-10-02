module "s3_distribution_pr01" {
  source = "../../modules/aws/s3_bucket"

  bucket_name = "enphoto-pr01"
}

module "s3_distribution_pr02" {
  source = "../../modules/aws/s3_bucket"

  bucket_name = "enphoto-pr02"
}

module "s3_distribution_pr03" {
  source = "../../modules/aws/s3_bucket"

  bucket_name = "enphoto-pr03"
}
