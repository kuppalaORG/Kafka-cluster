variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "instance_count" {
  type = number
  default = 3
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}

variable "key_name" {
  type = string
}

variable "name_prefix" {
  type = string
}
variable "route53_zone_id" {
  description = "Route53 Hosted Zone ID"
  type        = string
  default     = null
}

variable "domain_name" {
  description = "Domain name for broker DNS records"
  type        = string
  default     = null
}
variable "root_volume_size" {
  description = "Size of the root EBS volume in GB"
  type        = number
  default     = 20
}