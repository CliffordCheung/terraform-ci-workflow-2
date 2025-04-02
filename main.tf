provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "sctp-ce9-tfstate"
    key    = "clifford-s3-tf-ci.tfstate" #Change this
    region = "us-east-1"
  }
  required_version = ">= 1.0.0"
}

data "aws_caller_identity" "current" {}

locals {
  name_prefix = "clifford0402" //"${split("/", "${data.aws_caller_identity.current.arn}")[1]}"
  account_id  = data.aws_caller_identity.current.account_id
}

resource "aws_s3_bucket" "s3_tf" {
  bucket = "${local.name_prefix}-s3-tf-bkt-${local.account_id}"
}