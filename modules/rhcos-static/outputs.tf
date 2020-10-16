# output "ipv4" {
#     value = vsphere_virtual_machine.vm.id
# }

output "ignite" {
  value = data.ignition_config.vm.rendered
}