output "vm_name" {
    value = vsphere_virtual_machine.vm.name
}
output "default_ip" {
    value =vsphere_virtual_machine.vm.default_ip_address
}