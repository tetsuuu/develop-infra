variable "service_name" {}
variable "environment" {}
variable "short_env" {}
variable "domin_aliases" {}
variable "origin_id" {}
variable "bucket_domain_name" {}
variable "origin_path" {}
variable "access_identity" {}

locals {
  acm_arn = {
    "enphoto"  = "arn:aws:acm:us-east-1:579663348364:certificate/d117f281-073a-4663-ae6e-9f80e5869907"
    "kurapuri" = "arn:aws:acm:us-east-1:579663348364:certificate/9c7ebb00-5923-4f92-a290-0f3c08a1e617"
  }

  delegate_domain = {
    "enphoto"  = "en-photo.net"
    "kurapuri" = "kurapuri.com"
  }
}
