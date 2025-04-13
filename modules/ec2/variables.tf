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
