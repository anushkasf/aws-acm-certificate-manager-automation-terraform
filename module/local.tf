locals {

  common_tags = merge(var.common_additional_tags, {
    "Technical:ApplicationID"   = "APP-002775"
    "Technical:ApplicationName" = "Sysco Shop - Web"
    "Technical:Environment"     = var.environment
    "EKS_Namespace"             = var.eks_namespace
    "Technical:PlatformOwner"   = "CXDevOps@syscolabs.com"
  })
}
