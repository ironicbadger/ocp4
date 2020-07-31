

module "master" {
  source = "../rhcos"
  count  = length(var.master_macs)

  name             = "master${count.index + 1}"
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
  disk_size        = 16
  memory           = "4096"
  num_cpu          = "2"
}