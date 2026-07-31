output "s3_distribution_arn" {
  value       = aws_cloudfront_distribution.s3_distribution.arn
  description = "CloudFront S3 distribution ARN"
}

output "cloudfront_distribution_domain_name" {
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
  description = "CloudFront Distribution Domain Name"
}

output "cloudfront_aliases" {
  value       = aws_cloudfront_distribution.s3_distribution.aliases
  description = "CloudFront Aliases (Such as APEX, and www)"
}

