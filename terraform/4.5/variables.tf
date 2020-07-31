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

data "vsphere_virtual_machine" "template" {
  name          = "rhcos-4.4.3"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "rhel7" {
  name          = "rhel7"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

variable "cluster_slug" {
  type    = string
  default = "ocp45"
}

variable "domain_name" {
  type = string
  default = "ktz.lan"
}

variable "lb_mac" {
    description = "OCP 4 HAProxy MAC Address"
    type        = list(string)
    default     = ["00:50:56:b1:ef:ac"]
}

variable "bootstrap_mac" {
    description = "OCP 4 Bootstrap MAC Address"
    type        = list(string)
    default     = ["00:50:56:b1:c7:ae"]
}

variable "master_macs" {
    description = "OCP 4 Master MAC Address"
    type        = list(string)
    default     = ["00:50:56:b1:c7:ba", "00:50:56:b1:c7:bb", "00:50:56:b1:c7:bc"]
}

variable "worker_macs" {
    description = "OCP 4 Worker MAC Address"
    type        = list(string)
    #default     = ["00:50:56:b1:c7:ca", "00:50:56:b1:c7:cb"]
    default     = ["00:50:56:b1:c7:ca", "00:50:56:b1:c7:cb", "00:50:56:b1:c7:cc"]
}