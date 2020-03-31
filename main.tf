terraform {
  required_version = ">=0.12.0"

  required_providers {
    aws          = ">= 2.23.0"
  }

  backend "s3" {
    bucket = "terraform-state-env-01"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}