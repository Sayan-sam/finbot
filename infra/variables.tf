variable "region" {
    description = "AWS region"
    default = "ap-south-1"
}

variable "profile" {
    description = "AWS profile"
    default = "default"
}

variable "ec2_public_key" {
    description = "SSH public key"
    default = "assets/finbot_id_rsa.pub"
}