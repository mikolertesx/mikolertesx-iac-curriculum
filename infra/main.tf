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
  s3_origin_id   = "s3-website-origin"
}

module "website_s3" {
  source = "./modules/webBucket"

  s3_bucket_name = local.s3_bucket_name
  # Built by `npx nx build web` → apps/web/dist
  website_source_path = abspath("${path.root}/../apps/web/dist")
}

module "cloudfrontDistribution" {
  source = "./modules/cloudfrontDistribution"

  domain_name    = local.domain_name
  s3_origin_id   = local.s3_origin_id
  s3_domain_name = module.website_s3.s3_bucket_domain_name
}

data "aws_iam_policy_document" "allow_public_access_policy" {
  statement {
    sid     = "AllowOnlyCloudFront..."
    effect  = "Allow"
    actions = ["s3:GetObject"]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    resources = ["${module.website_s3.s3_bucket_arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [module.cloudfrontDistribution.s3_distribution_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "apply_allow_public_access_policy" {
  bucket = module.website_s3.s3_bucket_id
  policy = data.aws_iam_policy_document.allow_public_access_policy.json
}
