terraform {
  backend "s3" {
    bucket = "bsc.sandbox.terraform.state"
    key    = "serverless_poc"
    region = "us-east-2"
  }
}