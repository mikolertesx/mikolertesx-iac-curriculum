output "s3_distribution_arn" {
  value = aws_cloudfront_distribution.s3_distribution.arn
}

output "cloudfront_distribution_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}

output "cloudfront_aliases" {
  value = aws_cloudfront_distribution.s3_distribution.aliases
}

