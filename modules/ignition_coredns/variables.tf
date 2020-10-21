variable "ssh_key_file" {
  type = list(string)
}

variable "cluster_slug" {
  type = string
}

variable "cluster_domain" {
  type = string
}

variable "coredns_ip" {
  type = string
}

variable "loadbalancer_ip" {
  type = string
}

variable "bootstrap_ip" {
  type = string
}

variable "master_ips" {
  type = list(string)
}

variable "worker_ips" {
  type = list(string)
}
