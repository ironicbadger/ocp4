module "master" {
  source           = "../../rhcos"
  count            = length(var.master_macs)
  name             = "${var.cluster_slug}-master${count.index + 1}"
  folder           = "awesomo/redhat/${var.cluster_slug}"
  datastore        = data.vsphere_datastore.nvme500.id
  disk_size        = 40
  memory           = 8192
  num_cpu          = 4
  ignition         = file("../../../openshift/ignition-configs/master.ign")
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  datacenter_id    = yamldecode(file("~/.config/ocp/vsphere.yaml"))["vsphere-dc"]
  template         = data.vsphere_virtual_machine.template.id
  thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  network          = data.vsphere_network.network.id
  adapter_type     = data.vsphere_virtual_machine.template.network_interface_types[0]
  mac_address      = var.master_macs[count.index]
  domain_name      = var.domain_name
}

module "worker" {
  source           = "../../rhcos"
  count            = length(var.worker_macs)
  name             = "${var.cluster_slug}-worker${count.index + 1}"
  folder           = "awesomo/redhat/${var.cluster_slug}"
  datastore        = data.vsphere_datastore.nvme500.id
  disk_size        = 40
  memory           = 8192
  num_cpu          = 4
  ignition         = file("../../../openshift/ignition-configs/worker.ign")
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  datacenter_id    = yamldecode(file("~/.config/ocp/vsphere.yaml"))["vsphere-dc"]
  template         = data.vsphere_virtual_machine.template.id
  thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  network          = data.vsphere_network.network.id
  adapter_type     = data.vsphere_virtual_machine.template.network_interface_types[0]
  mac_address      = var.worker_macs[count.index]
  domain_name      = var.domain_name
}

module "bootstrap" {
  source           = "../../rhcos"
  count            = "${var.bootstrap_complete ? 0 : 1}"
  name             = "${var.cluster_slug}-bootstrap"
  folder           = "awesomo/redhat/${var.cluster_slug}"
  datastore        = data.vsphere_datastore.nvme500.id
  disk_size        = 40
  memory           = 8192
  num_cpu          = 4
  ignition         = data.ignition_config.ign.*.rendered[count.index]
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  datacenter_id    = yamldecode(file("~/.config/ocp/vsphere.yaml"))["vsphere-dc"]
  template         = data.vsphere_virtual_machine.template.id
  thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  network          = data.vsphere_network.network.id
  adapter_type     = data.vsphere_virtual_machine.template.network_interface_types[0]
  mac_address      = var.master_macs[count.index]
  domain_name      = var.domain_name
}

# module "lb" {
#   source = "../../rhcos"
#   count  = length(var.lb_mac)

#   name             = "${var.cluster_slug}-lb"
#   folder           = "awesomo/redhat/${var.cluster_slug}"
#   datastore        = data.vsphere_datastore.nvme500.id

#   disk_size        = 20
#   memory           = 1024
#   num_cpu          = 2

#   ignition         = ""

#   resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
#   guest_id         = data.vsphere_virtual_machine.template.guest_id
#   datacenter_id    = yamldecode(file("~/.config/ocp/vsphere.yaml"))["vsphere-dc"]
#   template         = data.vsphere_virtual_machine.template.id
#   thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned

#   network          = data.vsphere_network.network.id
#   adapter_type     = data.vsphere_virtual_machine.template.network_interface_types[0]
#   mac_address      = var.master_macs[count.index]
#   domain_name      = var.domain_name
# }
