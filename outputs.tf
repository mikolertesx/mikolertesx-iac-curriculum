output "cloudFront_domain" {
  value       = module.cloudfrontDistribution.cloudfront_distribution_domain_name
  description = "CloudFront distribution's domain name"
}

output "cloudfront_apex_domain" {
  value       = tolist(module.cloudfrontDistribution.cloudfront_aliases)[0]
  description = "CloudFront Apex domain"
}

output "cloudfront_www_domain" {
  value = one([
    for alias in module.cloudfrontDistribution.cloudfront_aliases : alias
    if startswith(alias, "www.")
  ])
  description = "CloudFront WWW domain"
}
