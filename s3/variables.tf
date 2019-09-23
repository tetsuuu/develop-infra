module "k_doue" {
  source = "../modules/aws/s3_bucket"
  bucket_name = "enphoto-dev-doue"
}

module "k_yoshida" {
  source = "../modules/aws/s3_bucket"
  bucket_name = "enphoto-dev-yoshida"
}

module "y_noda" {
  source = "../modules/aws/s3_bucket"
  bucket_name = "enphoto-dev-noda"
}

module "k_suzuki" {
  source = "../modules/aws/s3_bucket"
  bucket_name = "enphoto-dev-suzuki"
}

module "h_ota" {
  source = "../modules/aws/s3_bucket"
  bucket_name = "enphoto-dev-ota"
}

module "d_ito" {
  source = "../modules/aws/s3_bucket"
  bucket_name = "enphoto-dev-ito"
}
