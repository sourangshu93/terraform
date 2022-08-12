variable "vcdUser" {
    default = "user1"
}
variable "vcdPassword" {
    default = "Password1"
}
variable "orgName" {
    default = "poc-vcd05-Sandbox-t"
}
variable "vdcName" {
    default = "poc-vcd05-Sandbox-t-ovdc1"
}
locals {
    ovdc1 = var.vdcName=="poc-vcd05-Sandbox-t-ovdc1" ? "poc-vcd05-Sandbox-t-o11" : ""
    ovdc2 = var.vdcName=="poc-vcd05-Sandbox-t-ovdc2" ? "poc-vcd05-Sandbox-t-o12" : ""
    ovdc3 = var.vdcName=="poc-vcd05-Sandbox-t-ovdc3" ? "poc-vcd05-Sandbox-t-o13" : ""
    ovdc4 = var.vdcName=="poc-vcd05-Sandbox-t-ovdc5" ? "poc-vcd05-Sandbox-t-o14" : ""
    ovdc_network = coalesce(local.ovdc1,local.ovdc2,local.ovdc3,local.ovdc4)
}
variable "orgUrl" {
    default = "https://poc-vcd05.oc.example.com/api"
}
variable "infoblox_username" {
  default = "user1"
}
variable "infoblox_password" {
    default = "Password1"
}
variable "template_name" {
    default = "std-ubuntu-tmpl-2022"
}