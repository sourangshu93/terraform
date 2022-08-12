output "vm_name" {
    value = vsphere_virtual_machine.vm.name
    description = "Virtual Machine Name: "
}
output "default_ip" {
    value =vsphere_virtual_machine.vm.default_ip_address
    description = "Virtual Machine IP Address: "
}
output "cpus" {
    value =vsphere_virtual_machine.vm.num_cpus
    description = "No of vCPUs: "
}
output "memory" {
    value =vsphere_virtual_machine.vm.memory
    description = "Total Memory: "
}
