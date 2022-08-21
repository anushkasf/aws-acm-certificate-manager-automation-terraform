variable "acm_config" {
  #type = list(map(string))   # list of maps containing only strings
  # type = list(object({        # list of maps that contain multiple fields including strings, lists and maps.
  #   zone_id = string,
  #   domain_name = string,
  #   alternative_names = list(string),
  #   environment = string,
  #   validation_method = string
  # }))
}

variable "region" {}