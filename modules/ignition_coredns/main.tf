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
    content = file("${path.module}/files/openshift.lab.int.db")
  }
}

# the final output
data "ignition_config" "coredns" {
  users   = [data.ignition_user.core.rendered]
  files   = [data.ignition_file.corefile.rendered, data.ignition_file.openshift_lab_db.rendered]
  systemd = [data.ignition_systemd_unit.coredns.rendered]
}
