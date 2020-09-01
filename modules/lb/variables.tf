variable "lb_ip_address" {
  type = string
}

variable "api_backend_addresses" {
  type = list(string)
}

variable "ingress" {
  type    = list(string)
  default = []
}

variable "ssh_key_file" {
  type    = list(string)
}
