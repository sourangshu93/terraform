output "vm_name" {
  value = vcd_vapp_vm.terraform_vm.name
}
output "ip_address" {
  value = vcd_vapp_vm.terraform_vm.network[0].ip
}
output "deployed_on_vapp" {
  value = vcd_vapp_vm.terraform_vm.vapp_name
}
output "deployed_org" {
  value = vcd_vapp_vm.terraform_vm.org
}