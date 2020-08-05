variable "lb_ip_address" {
  type = string
}

variable "api_backend_addresses" {
  type = list(string)
}

variable "worker_ips" {
  type    = list(string)
  default = []
}

variable "ssh_public_key_path" {
  type    = string
  default = ""
}
