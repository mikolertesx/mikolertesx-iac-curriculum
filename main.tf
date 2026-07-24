terraform {
  backend "s3" {
    bucket       = "terraform-locks-1447"
    key          = "global/curriculum/prod"
    region       = "us-east-1"
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
  bucket           = local.s3_bucket_name

  tags = {
    Name        = "website host bucket"
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

# Remove this once we have CloudFront
resource "aws_s3_bucket_public_access_block" "remove_public_access_block" {
  bucket = local.s3_bucket_name

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "apply_allow_public_access_policy" {
  bucket = local.s3_bucket_name
  policy = data.aws_iam_policy_document.allow_public_access_policy.json

}

resource "aws_s3_object" "indexFile" {
  bucket       = local.s3_bucket_name
  key          = "index.html"
  source       = "./src/index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "stylesFile" {
  bucket       = local.s3_bucket_name
  key          = "styles.css"
  source       = "./src/styles.css"
  content_type = "text/css"
}

resource "aws_s3_object" "imageFile" {
  bucket       = local.s3_bucket_name
  key          = "portrait.jpeg"
  source       = "./src/portrait.jpeg"
  content_type = "image/jpeg"
}

resource "aws_s3_object" "jsFile" {
  bucket       = local.s3_bucket_name
  key          = "vistors.js"
  source       = "./src/visitors.js"
  content_type = "text/javascript"

}

data "aws_iam_policy_document" "allow_public_access_policy" {
  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    resources = [
      aws_s3_bucket.website_host_bucket.arn,
      "${aws_s3_bucket.website_host_bucket.arn}/*"
    ]
  }
}
