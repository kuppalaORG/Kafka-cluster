variable "ami_id" {
  description = "AMI to use for EC2"
  type        = string
}

variable "key_name" {
  description = "SSH Key pair"
  type        = string
}

variable "bucket" {}
variable "key" {}