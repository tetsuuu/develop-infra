variable "service_name" {}
variable "environment" {}
variable "short_env" {}
variable "maintenance_cidr_blocks" {}

locals {
  vpc_cidr_blocks = {
    "default" = "172.31.0.0/16"
  }

  availability_zones = {
    "default" = "ap-northeast-1a,ap-northeast-1c"
  }
}
