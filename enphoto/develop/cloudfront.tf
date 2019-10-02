module "k_doue_cf" {
  source = "../../modules/aws/cloudfront"

  environment        = var.environment
  service_name       = var.service_name
  short_env          = var.short_env
  origin_id          = "S3-enphoto-dev-doue/thumbnail"
  origin_path        = "/thumbnail"
  domin_aliases      = "dev-image-doue"
  bucket_domain_name = "enphoto-dev-doue.s3.amazonaws.com"
  access_identity    = "E3OIC1NJRUT25W"
}

module "k_yoshida_cf" {
  source = "../../modules/aws/cloudfront"

  environment        = var.environment
  service_name       = var.service_name
  short_env          = var.short_env
  origin_id          = "S3-enphoto-dev-yoshida/thumbnail"
  origin_path        = "/thumbnail"
  domin_aliases      = "dev-image-yoshida"
  bucket_domain_name = "enphoto-dev-yoshida.s3.amazonaws.com"
  access_identity    = "E3OIC1NJRUT25W"
}

module "y_noda_cf" {
  source = "../../modules/aws/cloudfront"

  environment        = var.environment
  service_name       = var.service_name
  short_env          = var.short_env
  origin_id          = "S3-enphoto-dev-noda/thumbnail"
  origin_path        = "/thumbnail"
  domin_aliases      = "dev-image-noda"
  bucket_domain_name = "enphoto-dev-noda.s3.amazonaws.com"
  access_identity    = "E3OIC1NJRUT25W"
}

module "k_suzuki_cf" {
  source = "../../modules/aws/cloudfront"

  environment        = var.environment
  service_name       = var.service_name
  short_env          = var.short_env
  origin_id          = "S3-enphoto-dev-suzuki/thumbnail"
  origin_path        = "/thumbnail"
  domin_aliases      = "dev-image-suzuki"
  bucket_domain_name = "enphoto-dev-suzuki.s3.amazonaws.com"
  access_identity    = "E3OIC1NJRUT25W"
}

module "h_ota_cf" {
  source = "../../modules/aws/cloudfront"

  environment        = var.environment
  service_name       = var.service_name
  short_env          = var.short_env
  origin_id          = "S3-enphoto-dev-ota/thumbnail"
  origin_path        = "/thumbnail"
  domin_aliases      = "dev-image-ota"
  bucket_domain_name = "enphoto-dev-ota.s3.amazonaws.com"
  access_identity    = "E3OIC1NJRUT25W"
}

module "d_ito_cf" {
  source = "../../modules/aws/cloudfront"

  environment        = var.environment
  service_name       = var.service_name
  short_env          = var.short_env
  origin_id          = "S3-enphoto-dev-ito/thumbnail"
  origin_path        = "/thumbnail"
  domin_aliases      = "dev-image-ito"
  bucket_domain_name = "enphoto-dev-ito.s3.amazonaws.com"
  access_identity    = "E3OIC1NJRUT25W"
}

module "r_fukuda_cf" {
  source = "../../modules/aws/cloudfront"

  environment        = var.environment
  service_name       = var.service_name
  short_env          = var.short_env
  origin_id          = "S3-enphoto-dev-fukuda/thumbnail"
  origin_path        = "/thumbnail"
  domin_aliases      = "dev-image-fukuda"
  bucket_domain_name = "enphoto-dev-fukuda.s3.amazonaws.com"
  access_identity    = "E3OIC1NJRUT25W"
}

module "s_yamamoto_cf" {
  source = "../../modules/aws/cloudfront"

  environment        = var.environment
  service_name       = var.service_name
  short_env          = var.short_env
  origin_id          = "S3-enphoto-dev-yamamoto/thumbnail"
  origin_path        = "/thumbnail"
  domin_aliases      = "dev-image-yamamoto"
  bucket_domain_name = "enphoto-dev-yamamoto.s3.amazonaws.com"
  access_identity    = "E3OIC1NJRUT25W"
}
