terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.73.0"
    }
  }

  backend "s3" {
    bucket  = "application-tf-state"
    region  = "us-east-1"
    key     = "terraform.tfstate"
    encrypt = true
  }
}

provider "aws" {}
