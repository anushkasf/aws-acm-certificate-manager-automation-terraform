output "domain_name" {
  value = var.domain_name

}

output "certificate_arn" {
  value = local.should_create_acm == 1 ? aws_acm_certificate.acm_certificate[0].arn : null

}

