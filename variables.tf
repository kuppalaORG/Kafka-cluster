variable "ami_id" {
  description = "AMI to use for EC2"
  type        = string
}

variable "key_name" {
  description = "SSH Key pair"
  type        = string
}

variable "bucket" {
  default = "firstawsbucketterra"
}

variable "key" {
  default = "kafka-tf-state/kafka-dev/terraform.tfstate"
}

# root/variables.tf
variable "route53_zone_id" {
  description = "The ID of the hosted zone"
  type        = string
}

variable "domain_name" {
  description = "The base domain name"
  type        = string
}

variable "instance_count" {
  description = "Number of Kafka broker instances"
  type        = number
  default     = 3
}
