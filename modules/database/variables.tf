variable "environment" {}
variable "service_name" {}
variable "short_env" {}
variable "maintenance_cidr_blocks" {}
variable "identifier" {}
variable "storage" {}
variable "max_storage" {}
variable "engine" {}
variable "engine_version" {}
variable "instance_class" {}
variable "name" {}
variable "user" {}
variable "password" {}
variable "backup_window" {}
variable "maintenance_window" {}
variable "db_subnet_group" {}
variable "target_vpc" {}
variable "public_sub" {}
variable "private_sub" {}

locals {
  enphoto = {
    "develop"     = "default.mysql5.7"
    "pullrequest" = "default.mysql5.7"
    "staging"     = "default.mysql5.7"
    "production"  = "enphoto-prod-rds-mysql"
  }

  kurapuri = {
    "develop"    = "default.mysql5.7"  //kurapuri dev has never been existing.
    "staging"    = "default.mysql5.7"
    "production" = "kurapuri-prod-rds-mysql"
  }
}
