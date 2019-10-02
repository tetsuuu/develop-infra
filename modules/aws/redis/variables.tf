variable "service_name" {}
variable "environment" {}
variable "short_env" {}
variable "node_type" {
  default = "cache.t2.micro"
}

variable "engine_version" {}
variable "cluster_name" {}
variable "target_vpc" {}
variable "private_subnets" {}
