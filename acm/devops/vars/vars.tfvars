acm_config = [
    {
        zone_id           = null
        name              = "proxy"
        domain_name       = "proxy.<ZONE_NAME>"
        subject_alternative_names = ["proxy.<ZONE_NAME>"]
        environment       = "PROD"
        eks_namespace     = "devops-prod"
        validation_method = "EMAIL"
    }   
]