terraform {
  required_version = "0.12.6"
}

provider "aws" {
  region  = "ap-northeast-1"
  version = "2.28"
}

variable "service_name" {}
variable "environment" {}
variable "short_env" {}
