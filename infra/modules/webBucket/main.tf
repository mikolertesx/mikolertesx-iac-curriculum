locals {
  content_types = {
    html        = "text/html"
    css         = "text/css"
    js          = "application/javascript"
    mjs         = "application/javascript"
    json        = "application/json"
    map         = "application/json"
    svg         = "image/svg+xml"
    png         = "image/png"
    jpg         = "image/jpeg"
    jpeg        = "image/jpeg"
    webp        = "image/webp"
    ico         = "image/x-icon"
    woff        = "font/woff"
    woff2       = "font/woff2"
    txt         = "text/plain"
    webmanifest = "application/manifest+json"
  }

  file_path = var.website_source_path
}

resource "aws_s3_bucket" "website_host_bucket" {
  bucket_namespace = "global"
  bucket           = var.s3_bucket_name

  tags = {
    Name        = "website host bucket"
    Environment = "Prod"
  }
}

resource "aws_s3_bucket_public_access_block" "remove_public_access_block" {
  bucket = aws_s3_bucket.website_host_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "website_files" {
  for_each = fileset(local.file_path, "**/*")

  bucket = aws_s3_bucket.website_host_bucket.id
  key    = each.value
  source = "${local.file_path}/${each.value}"
  etag   = filemd5("${local.file_path}/${each.value}")
  content_type = lookup(
    local.content_types,
    lower(element(split(".", each.value), length(split(".", each.value)) - 1)),
    "application/octet-stream"
  )
}
