@Library('infrastructure-pipeline-library@v2') _

properties([
    disableConcurrentBuilds()
])

timestamps {
    node {
        //vars and backend directory
        env.ENV_DIR = "vars"
        //define acmError
        def acmError = null  
        def awsAccountId = null
        
        try {
            
            checkout scm
            
            stage('Plan - CX-Shop-NonProd') {
                //cross account to access the NonProd from DevOps
                withAWS(role:"arn:aws:iam::<Account_ID>:role/Cross-Account-DevOps", roleAccount: "<Account_ID>") {
                    //call to terraform installed container
                    withAWSTFUtil('0.14.2') {
                        //working directory
                        dir ("acm/nonprod") {
                            script {
                                //execute terrafrom initiate and plan
                                def status = sh(script: "../../script/deploy.sh --varpath ${ENV_DIR} --region us-east-1 --plan", returnStatus: true)
                                if (![0, 2].contains(status)) {
                                    error("Terraform plan failed with exit code ${status}")
                                }
                            }
                            script {
                                def status = sh(script: "../../script/deploy.sh --varpath ${ENV_DIR} --region us-east-2 --plan", returnStatus: true)
                                if (![0, 2].contains(status)) {
                                    error("Terraform plan failed with exit code ${status}")
                                }
                            }
                        }
                    }
                }
            }

            if (env.BRANCH_NAME == "master") {
                stage('Apply - CX-Shop-NonProd') {
                    withAWS(role:"arn:aws:iam::<Account_ID>:role/Cross-Account-DevOps", roleAccount: "<Account_ID>") {
                        withAWSTFUtil('0.14.2') {
                            dir ("acm/nonprod") {
                                timeout(30) {
                                    //don't wait longer than 30 minutes for input
                                    input 'Do you want to apply changes?'
                                }
                                //execute terrafrom apply
                                sh "../../script/deploy.sh --varpath ${ENV_DIR} --region us-east-1"
                                sh "../../script/deploy.sh --varpath ${ENV_DIR} --region us-east-2"
                            }
                        }
                    }
                }                
            }

            stage('Plan - CX-Shop') {
                withAWS(role:"arn:aws:iam::<Account_ID>:role/Cross-Account-DevOps", roleAccount: "<Account_ID>") {
                    withAWSTFUtil('0.14.2') {
                        dir ("acm/prod") {
                            script {
                                def status = sh(script: "../../script/deploy.sh --varpath ${ENV_DIR} --region us-east-1 --plan", returnStatus: true)
                                if (![0, 2].contains(status)) {
                                    error("Terraform plan failed with exit code ${status}")
                                }
                            }
                            script {
                                def status = sh(script: "../../script/deploy.sh --varpath ${ENV_DIR} --region us-east-2 --plan", returnStatus: true)
                                if (![0, 2].contains(status)) {
                                    error("Terraform plan failed with exit code ${status}")
                                }
                            }
                        }
                    }
                }
            }

            if (env.BRANCH_NAME == "master") {
                stage('Apply - CX-Shop') {
                    withAWS(role:"arn:aws:iam::<Account_ID>:role/Cross-Account-DevOps", roleAccount: "<Account_ID>") {
                        withAWSTFUtil('0.14.2') {
                            dir ("acm/prod") {
                                timeout(30) {
                                    input 'Do you want to apply changes?'
                                }
                                sh "../../script/deploy.sh --varpath ${ENV_DIR} --region us-east-1"
                                sh "../../script/deploy.sh --varpath ${ENV_DIR} --region us-east-2"
                            }
                        }
                    }
                }
            }


            stage('Plan - CX-DevOps') {
                withAWSTFUtil('0.14.2') {
                    dir ("acm/devops-prod") {
                        sh "../../script/deploy.sh --varpath ${ENV_DIR} --region us-east-1 --plan"
                        //sh "../../script/deploy.sh --varpath ${ENV_DIR} --region us-east-2 --plan"
                    }
                }
            }

            if (env.BRANCH_NAME == "master") {
                stage('Apply - CX-DevOps') {
                    withAWSTFUtil('0.14.2') {
                        dir ("acm/devops-prod") {
                            timeout(30) {
                                input 'Do you want to apply changes?'
                            }
                            sh "../../script/deploy.sh --varpath ${ENV_DIR} --region us-east-1 "
                            //sh "../../script/deploy.sh --varpath ${ENV_DIR} --region us-east-2"
                        }
                    }
                }
            }
        }
        //catch execption and error
        catch (Throwable t) {
            //assign execption or error acmError and assign it to t
            acmError = t
            //if there is an error throw the error from t
            throw t
            }
        finally {
            //clean workspace
            cleanWs notFailBuild: true
        }
    }
}

