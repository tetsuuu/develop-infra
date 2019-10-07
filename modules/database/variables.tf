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
  parameter_group = {
    "enphoto"  = var.environment == "prodction" ? "enphoto-prod-rds-mysql" : "default.mysql5.7"
    "kurapuri" = var.environment == "prodction" ? "kurapuri-prod-rds-mysql" : "default.mysql5.7"
  }

  option_group = {
    "enphoto"  = var.environment == "prodction" ? "enphoto-prod-rds-mysql" : "default:mysql-5-7"
    "kurapuri" = var.environment == "prodction" ? "kurapuri-prod-rds-mysql" : "default:mysql-5-7"
  }

  log_level = {
    "enphoto"  = var.environment == "prodction" ? ["audit", "error", "general", "slowquery"] : ["error"]
    "kurapuri" = var.environment == "prodction" ? ["audit", "error", "general", "slowquery"] : ["error"]
  }
}
