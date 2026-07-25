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
  s3_origin_id = "s3-website-origin"
}

module "website_s3" {
  source = "./modules/webBucket"

  s3_bucket_name = local.s3_bucket_name
}

data "aws_iam_policy_document" "allow_public_access_policy" {
  statement {
    sid    = "AllowOnlyCloudFront..."
    effect = "Allow"
    actions = ["s3:GetObject"]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    resources = ["${module.website_s3.s3_bucket_arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "apply_allow_public_access_policy" {
  bucket = module.website_s3.s3_bucket_id
  policy = data.aws_iam_policy_document.allow_public_access_policy.json
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
    domain_name = module.website_s3.s3_bucket_domain_name
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
