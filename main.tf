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

  content_types = {
    html  = "text/html"
    css   = "text/css"
    js    = "application/javascript"
    jpeg  = "image/jpeg"
    jpg   = "image/jpeg"
    png   = "image/png"
    svg   = "image/svg+xml"
    ico   = "image/x-icon"
    json  = "application/json"
    txt   = "text/plain"
  }
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

resource "aws_s3_object" "website_files" {
  for_each = fileset("./src", "**/*")

  bucket = local.s3_bucket_name
  key    = each.value
  source = "./src/${each.value}"
  etag = filemd5("./src/${each.value}")
  content_type = lookup(
    local.content_types,
    lower(element(split(".", each.value), length(split(".", each.value)) -1)),
    "application/octet-stream"
  )
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
