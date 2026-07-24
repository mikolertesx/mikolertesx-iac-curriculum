terraform {
  backend "s3" {
    bucket = "terraform-locks-1447"
    key    = "global/curriculum/prod"
    region = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = "us-east-1"
}


locals {
  s3_bucket_name = "mikolertesx-curriculum-1447"
}

resource "aws_s3_bucket" "website_host_bucket" {
  bucket_namespace = "global"
  bucket = local.s3_bucket_name

  tags = {
    Name = "website host bucket"
    Environment = "Prod"
  }
}

resource "aws_s3_bucket_website_configuration" "website_static_config" {
  bucket = local.s3_bucket_name

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "indexFile" {
  bucket = local.s3_bucket_name
  key = "index.html"
  source = "./src/index.html"
}

resource "aws_s3_object" "stylesFile" {
  bucket = local.s3_bucket_name
  key = "styles.css"
  source = "./src/styles.css"
}

resource "aws_s3_object" "imageFile" {
  bucket = local.s3_bucket_name
  key = "portrait.jpeg"
  source = "./src/portrait.jpeg"
}

resource "aws_s3_object" "jsFile" {
  bucket = local.s3_bucket_name
  key = "vistors.js"
  source = "./src/visitors.js"
}
