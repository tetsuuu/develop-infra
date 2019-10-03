module "s3_distribution_pr01" {
  source = "../../modules/s3_bucket"

  bucket_name     = "enphoto-pr01"
  access_identity = "EQH4KPLGLS6Q5"
}

module "s3_distribution_pr02" {
  source = "../../modules/s3_bucket"

  bucket_name     = "enphoto-pr02"
  access_identity = "EQH4KPLGLS6Q5"
}

module "s3_distribution_pr03" {
  source = "../../modules/s3_bucket"

  bucket_name     = "enphoto-pr03"
  access_identity = "EQH4KPLGLS6Q5"
}
