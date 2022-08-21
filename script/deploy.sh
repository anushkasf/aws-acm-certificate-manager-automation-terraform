#!/bin/bash

# Defines the colors for output
RED='\033[0;31m'

usage()
{
 echo "${RED}Usage: $0 --varpath e.g. vars --plan${RED}\n"
 exit 1
}

if [ $# -lt 1 ]; then
  usage
fi

while [ $# -gt 0 ]; do
   if [[ $1 == *"--"* ]]; then
        v="${1/--/}"
        if [ -z "$2" ]; then
          declare $v="$v"
        else
          declare $v="$2"
        fi
   fi
  shift
done

if [ -z "$varpath" ]; then
  echo "expected e.g. ./deploy.sh --varpath vars"
else
  BACKEND_CONFIG="$varpath/backend-$region.hcl"
  VAR_FILE="$varpath/vars.tfvars"

  echo "$BACKEND_CONFIG"
  echo "$VAR_FILE"

  rm -rf .terraform
  rm -rf terraform.tfstate*

  echo '=========================terraform Initiate========================='

  terraform init -backend-config="$BACKEND_CONFIG"

  echo '=========================terraform plan============================='

  terraform plan -var-file "$VAR_FILE" -var region=$region -detailed-exitcode
  #terraform plan -var-file "$VAR_FILE" -var domain_name="$domain_name" -var alternative_names="$domain_name" -detailed-exitcode
  EXIT_CODE=$?

  
  # # Only executes terraform apply if terraform plan was successful and has a diff, with an exit code of 2
  if [ "$plan" != "plan" ] && [ $EXIT_CODE -eq 2 ]; then
    echo '=========================terraform apply============================='
    terraform apply -auto-approve -var-file "$VAR_FILE" -var region=$region
    #terraform apply -auto-approve -var-file "$VAR_FILE" -var domain_name="$domain_name" -var alternative_names="$domain_name"
  fi
fi

