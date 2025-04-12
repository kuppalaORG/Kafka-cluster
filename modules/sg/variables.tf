variable "vpc_id" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "allowed_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]  # Open to all for now (modify in prod)
}
