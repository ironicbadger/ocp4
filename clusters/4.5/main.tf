module "lb" {
  source        = "../../modules/lb"
  lb_ip_address = var.loadbalancer_ip

  api_backend_addresses = flatten([
    var.bootstrap_ip,
    var.master_ips]
  )
  ingress = var.worker_ips
}

module "lb_vm" {
  source           = "../../modules/rhcos"
  count            = length(var.lb_mac)
  name             = "${var.cluster_slug}-lb"
  folder           = "awesomo/redhat/${var.cluster_slug}"
  datastore        = data.vsphere_datastore.nvme500.id
  disk_size        = 16
  memory           = 1024
  num_cpu          = 2
  ignition         = module.lb.ignition
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  datacenter_id    = yamldecode(file("~/.config/ocp/vsphere.yaml"))["vsphere-dc"]
  template         = data.vsphere_virtual_machine.template.id
  thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  network          = data.vsphere_network.network.id
  adapter_type     = data.vsphere_virtual_machine.template.network_interface_types[0]
  mac_address      = var.lb_mac[count.index]
  domain_name      = var.domain_name
  ssh_key_file     = [file("~/.ssh/id_ed25519.pub")]
}

# output "ign" {
#   value = module.lb.ignition
# }

module "master" {
  source           = "../../modules/rhcos"
  count            = length(var.master_macs)
  name             = "${var.cluster_slug}-master${count.index + 1}"
  folder           = "awesomo/redhat/${var.cluster_slug}"
  datastore        = data.vsphere_datastore.nvme500.id
  disk_size        = 40
  memory           = 8192
  num_cpu          = 4
  ignition         = file(var.master_ignition_path)
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
  source           = "../../modules/rhcos"
  count            = length(var.worker_macs)
  name             = "${var.cluster_slug}-worker${count.index + 1}"
  folder           = "awesomo/redhat/${var.cluster_slug}"
  datastore        = data.vsphere_datastore.nvme500.id
  disk_size        = 40
  memory           = 8192
  num_cpu          = 4
  ignition         = file(var.worker_ignition_path)
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
  source           = "../../modules/rhcos"
  count            = "${var.bootstrap_complete ? 0 : 1}"
  name             = "${var.cluster_slug}-bootstrap"
  folder           = "awesomo/redhat/${var.cluster_slug}"
  datastore        = data.vsphere_datastore.nvme500.id
  disk_size        = 40
  memory           = 8192
  num_cpu          = 4
  ignition         = file(var.bootstrap_ignition_path)
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  datacenter_id    = yamldecode(file("~/.config/ocp/vsphere.yaml"))["vsphere-dc"]
  template         = data.vsphere_virtual_machine.template.id
  thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  network          = data.vsphere_network.network.id
  adapter_type     = data.vsphere_virtual_machine.template.network_interface_types[0]
  mac_address      = var.bootstrap_mac[count.index]
  domain_name      = var.domain_name
}
