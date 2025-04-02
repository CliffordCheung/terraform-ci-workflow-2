provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.20.1"
    }
  }
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

# resource "aws_s3_bucket" "s3_tf" {
#   bucket = "${local.name_prefix}-s3-tf-bkt-${local.account_id}"
# }

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "mybucket" {
  bucket = "${local.name_prefix}-s3-tf-bkt-${local.account_id}"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}