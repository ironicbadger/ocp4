module "master" {
  source = "../rhcos"
  count  = length(var.master_macs)

  name             = "${var.cluster_slug}.master${count.index + 1}"
  ignition         = "1234"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  folder           = "awesomo/redhat/ocp45"
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  datastore        = data.vsphere_datastore.nvme500.id
  network          = data.vsphere_network.network.id
  adapter_type     = data.vsphere_virtual_machine.template.network_interface_types[0]
  mac_address      = var.master_macs[count.index]
  datacenter_id    = yamldecode(file("~/.config/ocp/vsphere.yaml"))["vsphere-dc"]
  template         = data.vsphere_virtual_machine.template.id
  thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  domain_name      = var.domain_name
  disk_size        = 16
  memory           = "4096"
  num_cpu          = "2"
}

module "worker" {
  source = "../rhcos"
  count  = length(var.worker_macs)

  name             = "${var.cluster_slug}.worker${count.index + 1}"
  ignition         = "1234"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  folder           = "awesomo/redhat/ocp45"
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  datastore        = data.vsphere_datastore.nvme500.id
  network          = data.vsphere_network.network.id
  adapter_type     = data.vsphere_virtual_machine.template.network_interface_types[0]
  mac_address      = var.worker_macs[count.index]
  datacenter_id    = yamldecode(file("~/.config/ocp/vsphere.yaml"))["vsphere-dc"]
  template         = data.vsphere_virtual_machine.template.id
  thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  domain_name      = var.domain_name
  disk_size        = 16
  memory           = "4096"
  num_cpu          = "2"
}

module "bootstrap" {
  source = "../rhcos"
  count  = length(var.bootstrap_mac)

  name             = "${var.cluster_slug}.bootstrap"
  ignition         = "1234"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  folder           = "awesomo/redhat/ocp45"
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  datastore        = data.vsphere_datastore.nvme500.id
  network          = data.vsphere_network.network.id
  adapter_type     = data.vsphere_virtual_machine.template.network_interface_types[0]
  mac_address      = var.bootstrap_mac[count.index]
  datacenter_id    = yamldecode(file("~/.config/ocp/vsphere.yaml"))["vsphere-dc"]
  template         = data.vsphere_virtual_machine.template.id
  thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  domain_name      = var.domain_name
  disk_size        = 16
  memory           = "4096"
  num_cpu          = "2"
}

module "lb" {
  source = "../rhcos"
  count  = length(var.lb_mac)

  name             = "${var.cluster_slug}-lb"
  ignition         = "1234"
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  folder           = "awesomo/redhat/ocp45"
  guest_id         = data.vsphere_virtual_machine.rhel7.guest_id
  datastore        = data.vsphere_datastore.nvme500.id
  network          = data.vsphere_network.network.id
  adapter_type     = data.vsphere_virtual_machine.rhel7.network_interface_types[0]
  mac_address      = var.lb_mac[count.index]
  datacenter_id    = yamldecode(file("~/.config/ocp/vsphere.yaml"))["vsphere-dc"]
  template         = data.vsphere_virtual_machine.rhel7.id
  thin_provisioned = data.vsphere_virtual_machine.rhel7.disks.0.thin_provisioned
  domain_name      = var.domain_name
  disk_size        = 20
  memory           = "4096"
  num_cpu          = "2"
}