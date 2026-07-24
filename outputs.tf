output "cloudFront_domain" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
  description = "CloudFront distribution's domain name"
}

output "cloudFront_alternative_names" {
  value = aws_cloudfront_distribution.s3_distribution.aliases
  description = "CloudFront distribution's aliases"
}
