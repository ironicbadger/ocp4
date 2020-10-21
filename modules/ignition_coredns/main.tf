data "ignition_user" "core" {
  name                = "core"
  ssh_authorized_keys = var.ssh_key_file
}

data "ignition_systemd_unit" "coredns" {
  name    = "coredns.service"
  content = file("${path.module}/files/coredns.service")
}

data "ignition_file" "corefile" {
  path = "/opt/coredns/Corefile"
  mode = "420" // 0644
  content {
    content = file("${path.module}/files/Corefile")
  }
}

data "ignition_file" "openshift_lab_db" {
  path = "/opt/coredns/openshift.lab.int.db"
  mode = "420" // 0644
  content {
    content = templatefile("${path.module}/files/openshift.lab.int.db.tmpl", {
      cluster_slug    = var.cluster_slug,
      cluster_domain  = var.cluster_domain,
      coredns_ip      = var.coredns_ip,
      loadbalancer_ip = var.loadbalancer_ip,
      bootstrap_ip    = var.bootstrap_ip,
      master_ips      = var.master_ips,
      worker_ips      = var.worker_ips
    })
  }
}

# the final output
data "ignition_config" "coredns" {
  users   = [data.ignition_user.core.rendered]
  files   = [data.ignition_file.corefile.rendered, data.ignition_file.openshift_lab_db.rendered]
  systemd = [data.ignition_systemd_unit.coredns.rendered]
}
