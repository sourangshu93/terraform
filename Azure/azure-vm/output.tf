output "vm_name" {
  value = azurerm_linux_virtual_machine.terraform-vm.name
}
output "public_ip_address" {
  value = azurerm_linux_virtual_machine.terraform-vm.public_ip_address
}
output "private_ip_address" {
  value = azurerm_linux_virtual_machine.terraform-vm.private_ip_address
}