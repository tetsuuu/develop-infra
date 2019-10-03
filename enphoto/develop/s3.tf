module "k_doue_s3" {
  source = "../../modules/s3_bucket"

  bucket_name = "enphoto-dev-doue"
}

module "k_yoshida_s3" {
  source = "../../modules/s3_bucket"

  bucket_name = "enphoto-dev-yoshida"
}

module "y_noda_s3" {
  source = "../../modules/s3_bucket"

  bucket_name = "enphoto-dev-noda"
}

module "k_suzuki_s3" {
  source = "../../modules/s3_bucket"

  bucket_name = "enphoto-dev-suzuki"
}

module "h_ota_s3" {
  source = "../../modules/s3_bucket"

  bucket_name = "enphoto-dev-ota"
}

module "d_ito_s3" {
  source = "../../modules/s3_bucket"

  bucket_name = "enphoto-dev-ito"
}

module "r_fukuda_s3" {
  source = "../../modules/s3_bucket"

  bucket_name = "enphoto-dev-fukuda"
}

module "s_yamamoto_s3" {
  source = "../../modules/s3_bucket"

  bucket_name = "enphoto-dev-yamamoto"
}
