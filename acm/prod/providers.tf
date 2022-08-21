terraform {
  required_providers {
    aws = ">= 3.63"
  }
  required_version = ">= 0.13" #>= 1.1.8

  backend "s3" {}
}

provider "aws" {
  region = var.region
}