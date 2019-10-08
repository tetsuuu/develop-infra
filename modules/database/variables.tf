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
variable "vpc_cidr_block" {}
variable "sg_description" {}
variable "db_identifier" {}

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

  developers_ips = {
    "default"  = ["39.110.205.167/32", "118.103.95.42/32", "106.72.0.33/32", "182.250.243.17/32", "220.247.1.211/32"]
  }
}
