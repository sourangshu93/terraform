variable "vm_name" {
    type = string
}
variable "vm_size" {
    type = string
}
variable "public_ip" {
    type = string
}
locals {
    small=var.vm_size == "Small" ? "Standard_DS1" : ""
    medium=var.vm_size == "Medium" ? "Standard_B2s" : ""
    large=var.vm_size == "Large" ? "Standard_D4s_v3" : ""
    instance_size=coalesce(local.small,local.medium,local.large)
}
