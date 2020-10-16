locals {
  ignition_encoded = "data:text/plain;charset=utf-8;base64,${base64encode(var.ignition)}"
}

data "ignition_filesystem" "root" {
  name = "root"
  path = "/"
}

data "ignition_file" "hostname" {

  filesystem = "root"
  path       = "/etc/hostname"
  mode       = "775"

  content {
    content = var.name
  }
}

data "ignition_file" "static_ip" {
  filesystem = "root"
  path       = "/etc/sysconfig/network-scripts/ifcfg-ens192"
  mode       = "420"

  content {
    content = templatefile("${path.module}/ifcfg.tmpl", {
      dns            = var.dns_addresses,
      gateway        = var.gateway,
      machine_cidr   = var.machine_cidr,
      ip_address     = var.ipv4_address,
      cluster_domain = var.cluster_domain
    })
  }
}

data "ignition_config" "vm" {

  append {
    source = local.ignition_encoded
  }
  files = [
    data.ignition_file.hostname.rendered,
    data.ignition_file.static_ip.rendered
  ]
}

resource "vsphere_virtual_machine" "vm" {

  name               = var.name
  resource_pool_id   = var.resource_pool_id
  datastore_id       = var.datastore
  num_cpus           = var.num_cpu
  memory             = var.memory
  memory_reservation = var.memory
  guest_id           = var.guest_id
  folder             = var.folder
  enable_disk_uuid   = "true"

  wait_for_guest_net_timeout  = "0"
  wait_for_guest_net_routable = "false"

  network_interface {
    network_id   = var.network
    adapter_type = var.adapter_type
  }

  disk {
    label            = "disk0"
    size             = var.disk_size
    thin_provisioned = var.thin_provisioned
  }

  clone {
    template_uuid = var.template
  }

  extra_config = {
    "guestinfo.ignition.config.data"          = base64encode(data.ignition_config.vm.rendered)
    "guestinfo.ignition.config.data.encoding" = "base64"

    # requires rhcos 4.6 but tf provider doesnt yet support ignition v3 which 4.6 requires
    # https://github.com/terraform-providers/terraform-provider-ignition/pull/69
    #"guestinfo.afterburn.initrd.network-kargs" = "ip=${var.ipv4_address}::${var.gateway}:${var.netmask}:${var.name}:ens192:off"
  }
}
