terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

#-----------------------------------------
# Provider: AWS
#-----------------------------------------
provider "aws" {
  region = "us-west-2"
}