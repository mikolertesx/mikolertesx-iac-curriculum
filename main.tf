provider "aws" {
  region = "aws-east-1"
}

terraform {
  backend "s3" {
    bucket = "terraform-locks-1447"
    key    = "global/curriculum/prod"
    region = "us-east-1"
  }
}
