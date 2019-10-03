module "k_doue_s3" {
  source = "../../modules/s3_bucket"

  bucket_name     = "enphoto-dev-doue"
  access_identity = "E3OIC1NJRUT25W"
}

module "k_yoshida_s3" {
  source = "../../modules/s3_bucket"

  bucket_name     = "enphoto-dev-yoshida"
  access_identity = "E3OIC1NJRUT25W"
}

module "y_noda_s3" {
  source = "../../modules/s3_bucket"

  bucket_name     = "enphoto-dev-noda"
  access_identity = "E3OIC1NJRUT25W"
}

module "k_suzuki_s3" {
  source = "../../modules/s3_bucket"

  bucket_name     = "enphoto-dev-suzuki"
  access_identity = "E3OIC1NJRUT25W"
}

module "h_ota_s3" {
  source = "../../modules/s3_bucket"

  bucket_name     = "enphoto-dev-ota"
  access_identity = "E3OIC1NJRUT25W"
}

module "d_ito_s3" {
  source = "../../modules/s3_bucket"

  bucket_name     = "enphoto-dev-ito"
  access_identity = "E3OIC1NJRUT25W"
}

module "r_fukuda_s3" {
  source = "../../modules/s3_bucket"

  bucket_name     = "enphoto-dev-fukuda"
  access_identity = "E3OIC1NJRUT25W"
}

module "s_yamamoto_s3" {
  source = "../../modules/s3_bucket"

  bucket_name     = "enphoto-dev-yamamoto"
  access_identity = "E3OIC1NJRUT25W"
}
