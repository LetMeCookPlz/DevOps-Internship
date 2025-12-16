terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "tymur-s3-tf-state"
    key            = "terraform/terraform.tfstate"
    region         = "eu-central-1" 
  }
}

provider "aws" {
  region = var.region
}