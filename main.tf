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
  domain_name    = "miguel-gro.click"

  content_types = {
    html = "text/html"
    css  = "text/css"
    js   = "application/javascript"
    jpeg = "image/jpeg"
  }

  s3_origin_id = "s3-website-origin"
}

resource "aws_s3_bucket" "website_host_bucket" {
  bucket_namespace = "global"
  bucket           = local.s3_bucket_name

  tags = {
    Name        = "website host bucket"
    Environment = "Prod"
  }
}

resource "aws_s3_bucket_public_access_block" "remove_public_access_block" {
  bucket = local.s3_bucket_name

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
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
  etag   = filemd5("./src/${each.value}")
  content_type = lookup(
    local.content_types,
    lower(element(split(".", each.value), length(split(".", each.value)) - 1)),
    "application/octet-stream"
  )
}

resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "default AOC"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  enabled             = true
  default_root_object = "index.html"
  aliases             = [local.domain_name, "www.${local.domain_name}"]

  origin {
    domain_name              = aws_s3_bucket.website_host_bucket.bucket_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = local.s3_origin_id
  }
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.site_certificate.arn
    ssl_support_method  = "sni-only"
  }
}

resource "aws_acm_certificate" "site_certificate" {
  domain_name       = local.domain_name
  validation_method = "DNS"
  subject_alternative_names = [
    "www.${local.domain_name}"
  ]
}

data "aws_route53_zone" "site" {
  name         = local.domain_name
  private_zone = false
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.site_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  zone_id         = data.aws_route53_zone.site.zone_id
  name            = each.value.name
  type            = each.value.type
  ttl             = 60
  records         = [each.value.record]
}

resource "aws_route53_record" "apex" {
  zone_id = data.aws_route53_zone.site.zone_id
  name    = local.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.site.zone_id
  name    = "www.${local.domain_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}


data "aws_iam_policy_document" "allow_public_access_policy" {
  statement {
    sid    = "AllowOnlyCloudFront${aws_cloudfront_distribution.s3_distribution.id}ToDeliverS3Content"
    effect = "Allow"

    actions = [
      "s3:GetObject"
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    resources = [
      "${aws_s3_bucket.website_host_bucket.arn}/*"
    ]

    # Test so that only one distribution can deliver it.
    condition {
      test = "StringEquals"
      variable = "AWS:SourceArn"
      values = [
        aws_cloudfront_distribution.s3_distribution.arn
      ]
    }
  }
}
