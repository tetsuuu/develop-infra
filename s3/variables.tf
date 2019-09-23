variable "service_name" {
  default = "enphoto"
}

variable "short_env" {
  default = "dev"
}

variable "environment" {
  default = "develop"
}

//variable "dev_s3_bucket" {
//  default = {
//    name = "dev_s3_bucket"
//    buckets = {
//      bucket1 = {
//        name = "doue"
//        arn  = "enphoto-dev-doue"
//      }
//      bucket2 = {
//        name = "yoshida"
//        arn  = "enphoto-dev-doue"
//      }
//      bucket3 = {
//        name = "noda"
//        arn  = "enphoto-dev-doue"
//      }
//      bucket4 = {
//        name = "suzuki"
//        arn  = "enphoto-dev-doue"
//      }
//      bucket5 = {
//        name = "ohta"
//        arn  = "enphoto-dev-doue"
//      }
//      bucket6 = {
//        name = "ito"
//        arn  = "enphoto-dev-doue"
//      }
//    }
//  }
//}

locals {
  s3_buckets = {
    name = [
      "enphoto-dev-doue",
      "enphoto-dev-yoshida",
      "enphoto-dev-noda",
      "enphoto-dev-suzuki",
      "enphoto-dev-ohta",
      "enphoto-dev-ito"
    ]
  }
}
