terraform {
  backend "s3" {
    bucket         = var.backend_s3_bucket
    key            = var.backend_s3_key
    region         = var.backend_s3_region
    encrypt        = true
    role_arn       = var.backend_s3_role_arn
    dynamodb_table = var.backend_s3_dynamodb_table
  }
}

provider "aws" {
  region = "ap-northeast-1"
}
