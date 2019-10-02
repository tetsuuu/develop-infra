variable "service_name" {
  default = "kurapuri"
}

variable "short_env" {
  default = "stg"
}

variable "environment" {
  default = "staging"
}

variable "region" {
  default = "ap-northeast-1"
}

variable "state_bucket" {
  default = "uluru-kurapuri-infra-tfstate"
}

variable "maintenance_cidr_blocks" {
  type = "list"
  default = [
    "118.103.95.42/32",
    "39.110.205.167/32"
  ]
}

variable "delegate_domain" {
  default = "kurapuri.com"
}
