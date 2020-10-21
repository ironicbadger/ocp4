variable "name" {
  type = string
}

variable "ignition" {
  type    = string
  default = ""
}

variable "ignition_url" {
  type    = string
  default = ""
}

variable "resource_pool_id" {
  type = string
}

variable "folder" {
  type = string
}

variable "datastore" {
  type = string
}

variable "network" {
  type = string
}

variable "adapter_type" {
  type = string
}

variable "guest_id" {
  type = string
}

variable "template" {
  type = string
}

variable "thin_provisioned" {
  type = string
}

variable "disk_size" {
  type = string
}

variable "memory" {
  type = string
}

variable "num_cpu" {
  type = string
}

variable "cluster_domain" {
  type = string
}

variable "machine_cidr" {
  type = string
}

variable "gateway" {
  type = string
}

variable "ipv4_address" {
  type = string
}

variable "netmask" {
  type = string
}

variable "dns_address" {
  type = string
}
