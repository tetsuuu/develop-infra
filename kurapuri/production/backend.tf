terraform {
  backend "s3" {
    bucket  = "uluru-kurapuri-infra-tfstate"
    key     = "infra/production/terraform.tfstate"
    region  = "ap-northeast-1"
  }
}
