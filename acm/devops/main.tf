module "acm" {
  source            = "../../module"
  for_each          = {for acm in var.acm_config: acm.name => acm}
  region            = var.region
  zone_id           = each.value.zone_id
  domain_name       = each.value.domain_name
  subject_alternative_names = each.value.subject_alternative_names
  environment       = each.value.environment
  eks_namespace     = each.value.eks_namespace
  validation_method = each.value.validation_method
}