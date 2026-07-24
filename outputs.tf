output "cloudFront_domain" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
  description = "CloudFront distribution's domain name"
}

output "cloudfront_apex_domain" {
  value = tolist(aws_cloudfront_distribution.s3_distribution.aliases)[0]
  description = "CloudFront Apex domain"
}

output "cloudfront_www_domain" {
  value = one([
    for alias in aws_cloudfront_distribution.s3_distribution.aliases : alias
    if startswith(alias, "www.")
  ])
  description = "CloudFront WWW domain"
}
