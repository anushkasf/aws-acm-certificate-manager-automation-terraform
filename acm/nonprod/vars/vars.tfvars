acm_config = [
    {
        zone_id           = "<ZONE_ID>"                                             #ZONE_ID or null
        name              = "backend-stag.<ZONE_NAME>"
        domain_name       = "backend-stag.<ZONE_NAME>"
        subject_alternative_names = [
            "devops-test-java-service-dev.<ZONE_NAME>",
            "portal-dev.<ZONE_NAME>",
            "portal-qa.<ZONE_NAME>",
            "portal-stag.<ZONE_NAME>",
            "backend-dev.<ZONE_NAME>",
            "backend-qa.<ZONE_NAME>",
            "backend-stag.<ZONE_NAME>",
            "slack-alert.<ZONE_NAME>"
        ]
        environment       = "NONPROD"
        eks_namespace     = "stag"
        validation_method = "DNS"
    },
    {
        zone_id           = null                                                    #ZONE_ID or null
        name              = "argo-cd.<ZONE_NAME>"
        domain_name       = "argo-cd.shop-platform-np.<ZONE_NAME>"
        subject_alternative_names = [
            "argo-cd.shop-platform-nonprod.<ZONE_NAME>",
            "argo-cd.shop-platform-perf.<ZONE_NAME>"
        ]
        environment       = "NONPROD"
        eks_namespace     = "argo-cd"
        validation_method = "EMAIL"
    }
]
