###########################
## OCP Cluster Vars

variable "cluster_slug" {
  type    = string
  default = "ocp46"
}

variable "domain_name" {
  type    = string
  default = "ktz.lan"
}

variable "bootstrap_complete" {
  type    = string
  default = "false"
}

##############
## VMware templates to clone

data "vsphere_virtual_machine" "template" {
  name          = "rhcos-4.6.0-0.nightly-2020-09-29-013537-x86_64-vmware.x86_64"
  datacenter_id = data.vsphere_datacenter.dc.id
}

################
## VMware vars - unlikely to need to change between releases of OCP

provider "vsphere" {
  user           = yamldecode(file("~/.config/ocp/vsphere.yaml"))["vsphere-user"]
  password       = yamldecode(file("~/.config/ocp/vsphere.yaml"))["vsphere-password"]
  vsphere_server = yamldecode(file("~/.config/ocp/vsphere.yaml"))["vsphere-server"]

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = yamldecode(file("~/.config/ocp/vsphere.yaml"))["vsphere-dc"]
}

data "vsphere_compute_cluster" "cluster" {
  name          = yamldecode(file("~/.config/ocp/vsphere.yaml"))["vsphere-cluster"]
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "nvme500" {
  name          = "nvme500"
  datacenter_id = data.vsphere_datacenter.dc.id
}

##########
## Ignition

provider "ignition" {
  # https://www.terraform.io/docs/providers/ignition/index.html
  version = "1.2.1"
}

variable "ignition" {
  type    = string
  default = ""
}

#########
## Machine variables

variable "bootstrap_ignition_path" {
  type    = string
  default = ""
}

variable "master_ignition_path" {
  type    = string
  default = ""
}

variable "worker_ignition_path" {
  type    = string
  default = ""
}

variable "master_ips" {
  type    = list(string)
  default = []
}

variable "worker_ips" {
  type    = list(string)
  default = []
}

variable "bootstrap_ip" {
  type    = string
  default = ""
}

variable "loadbalancer_ip" {
  type    = string
  default = ""
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

variable "dns_address" {
  type = string
}

variable "netmask" {
  type = string
}
