provider "aws" {
  region = var.region
  profile = var.profile
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    } 
  }
}

resource "aws_s3_bucket" "finbot_state" {
  bucket = "finbot-terraform-state"
  tags = {
    Name        = "Finbot Terraform State"
    Environment = "Hackathon"
  }
}
