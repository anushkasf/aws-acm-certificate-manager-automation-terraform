variable "domain_name" {
  type = string
}

variable "subject_alternative_names" {
  type        = list(string)
  default     = []
}

variable "region" {
  type    = string
}

variable "primary_region" {
  type    = string
  default = "us-east-1"
}

variable "secondary_region" {
  type    = string
  default = "us-east-2"
}

variable "environment" {
  description = "Name of the environment"
  default     = "NONPROD"
}

variable "common_additional_tags" {
  type        = map(string)
  default     = {}
}

variable "zone_id" {
  type        = string
  default     = "Z1Y68HCH9RR79G"
}

variable "validation_method" {
  type        = string
  default     = "DNS"
}

variable "eks_namespace" {
  type        = string
}

variable "global_dns" {
  type        = bool
  default = false
}

