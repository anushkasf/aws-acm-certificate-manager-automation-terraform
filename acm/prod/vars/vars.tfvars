acm_config = [
    {
        zone_id           = "<ZONE_ID>"                                             #ZONE_ID or null
        name              = "<backend-prod>.<ZONE_NAME>"
        domain_name       = "<backend-prod>.<ZONE_NAME>"
        subject_alternative_names = [
            "backend-prod.<ZONE_NAME>",
            "frontend-prod.<ZONE_NAME>"
            ]
        environment       = "PROD"
        eks_namespace     = "prod"
        validation_method = "DNS"
    },
    {
        zone_id           = null                                                    #ZONE_ID or null
        name              = "argo-cd"
        domain_name       = "<argo-cd-prod>.<ZONE_NAME>"
        subject_alternative_names = [
            "argo-workflow-prod.<ZONE_NAME>",
            "argo-cd-prod.<ZONE_NAME>"
        ]
        environment       = "PROD"
        eks_namespace     = "argo-cd"
        validation_method = "EMAIL"
    }
]
