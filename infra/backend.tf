terraform {
  backend "s3" {
    bucket = "finbot-terraform-state"
    key    = "finbot/terraform.tfstate"
    region = "ap-south-1"
  }
}
