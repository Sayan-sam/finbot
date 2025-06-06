variable "region" {
    description = "AWS region"
    default = "ap-south-1"
}

variable "ec2_public_key" {
    description = "SSH public key"
    default = "assets/finbot_id_rsa.pub"
}

variable "deep_seek_api_key" {
    description = "DeepSeek API Key"
    default     = ""
}
