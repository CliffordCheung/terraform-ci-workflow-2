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

resource "aws_s3_bucket" "s3_tf" {
  #checkov:skip=CKV_AWS_20:The bucket is a public static content host
  #checkov:skip=CKV_AWS_145:The bucket is with default encryption
  #checkov:skip=CKV_AWS_21:The bucket has versioning control
  #checkov:skip=CKV_AWS_6:The bucket has a public access block
  #checkov:skip=CKV_AWS_144:The S3 bucket has cross-region replication enabled
  #checkov:skip=CKV_AWS_18:The S3 bucket has has access logging enabled
  #checkov:skip=CKV_AWS_61:The S3 bucket has a lifecycle configuration
  bucket = "${local.name_prefix}-s3-tf-bkt-${local.account_id}"
}