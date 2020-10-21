output "ignition" {
  value = data.ignition_config.coredns.rendered
}
