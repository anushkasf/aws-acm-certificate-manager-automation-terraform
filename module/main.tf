locals {
  primary                   = var.region == "us-east-1" ? 1 : null
  dns_validated_acm         = var.validation_method == "DNS" ? 1 : null
  secondary                 = var.region == "us-east-2" && (can(regex("prod", var.eks_namespace)) || can(regex("qa", var.eks_namespace)) || can(regex("argo-cd", var.eks_namespace))) ? 1 : 0 # Simply added "argo-cd" logic to this existing line. Reference: DOPS-7230
  should_create_acm         = coalesce(local.primary, local.dns_validated_acm, local.secondary)
  distinct_domain_names     = distinct(concat([var.domain_name], [for s in var.subject_alternative_names : replace(s, "*.", "")]))
  validation_domains        = local.should_create_acm == 1 ? [for k, v in aws_acm_certificate.acm_certificate[0].domain_validation_options : tomap(v) if contains(local.distinct_domain_names, v.domain_name)] : []
  domain_name               = var.region == "us-east-2" ? (var.global_dns ? var.domain_name : replace(var.domain_name, "us-east-1", "us-east-2")) : var.domain_name
  subject_alternative_names = var.region == "us-east-2" ? (var.global_dns ? var.subject_alternative_names : [for s in var.subject_alternative_names : replace(s, "us-east-1", "us-east-2")]) : var.subject_alternative_names
}

# Request public certificates from the amazon certificate manager.
resource "aws_acm_certificate" "acm_certificate" {
  count                     = local.should_create_acm
  domain_name               = local.domain_name
  subject_alternative_names = local.subject_alternative_names
  validation_method         = var.validation_method

  lifecycle {
    create_before_destroy = true
    ignore_changes = [
      subject_alternative_names,
    ]
  }

  tags = local.common_tags
}

# Create a record set in route 53 for domain validatation
resource "aws_route53_record" "route53_record" {
  count = var.validation_method == "DNS" ? length(local.distinct_domain_names) : 0

  zone_id         = var.zone_id
  name            = element(local.validation_domains, count.index)["resource_record_name"]
  type            = element(local.validation_domains, count.index)["resource_record_type"]
  ttl             = 300
  allow_overwrite = true

  records = [
    element(local.validation_domains, count.index)["resource_record_value"]
  ]

  depends_on = [aws_acm_certificate.acm_certificate]
}


# Validate acm certificates
resource "aws_acm_certificate_validation" "acm_certificate_validation" {
  count                   = var.validation_method == "DNS" ? 1 : 0
  certificate_arn         = aws_acm_certificate.acm_certificate[count.index].arn
  validation_record_fqdns = aws_route53_record.route53_record.*.fqdn
}

