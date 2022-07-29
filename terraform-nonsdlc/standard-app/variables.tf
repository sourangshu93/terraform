variable "vm_name" {
    type = string
}
variable "cpu"{
    type = number
}
variable "memory"{
    type = number
}
variable "orgName" {
    type = string
}
variable "vdcName" {
    type = string
}
locals {
    ovdc1 = var.vdcName=="wdc-vcd05-NonSDLC-DevOps-t-ovdc1" ? "wdc-vcd05-NonSDLC-DevOps-t-o11" : ""
    ovdc2 = var.vdcName=="wdc-vcd05-NonSDLC-DevOps-t-ovdc2" ? "wdc-vcd05-NonSDLC-DevOps-t-o22" : ""
    ovdc3 = var.vdcName=="wdc-vcd05-NonSDLC-DevOps-t-ovdc4" ? "wdc-vcd05-NonSDLC-DevOps-t-o41" : ""
    ovdc4 = var.vdcName=="wdc-vcd05-NonSDLC-DevOps-t-ovdc5" ? "wdc-vcd05-NonSDLC-DevOps-t-o52" : ""
    ovdc5 = var.vdcName=="wdc-vcd05-CorpITOpsSandbox-t-ovdc1" ? "wdc-vcd05-CorpITOpsSandbox-t-o11" : ""
    ovdc6 = var.vdcName=="wdc-vcd05-dops-srdservices-t-ovdc1" ? "wdc-vcd05-dops-srdservices-t-o11" : ""
    ovdc7 = var.vdcName=="wdc-vcd05-CorpITTest-t-Test12-ovdc6" ? "wdc-vcd05-CorpITTest-t-Test12-o61": ""
    ovdc8 = var.vdcName=="wdc-vcd05-CorpITTest-t-UAT2-ovdc4" ? "wdc-vcd05-CorpITTest-t-UAT2-o41": ""
    ovdc_network = coalesce(local.ovdc1,local.ovdc2,local.ovdc3,local.ovdc4,local.ovdc5,local.ovdc6,local.ovdc7,local.ovdc8)
}
variable "template_name" {
    type = string
}
variable "additional_disk" {
    type = string
  
}
variable "disk_size_in_mb" {
    type = string
}
variable "ouname" {
    type = string
}
variable "inventory" {
    type = string
}