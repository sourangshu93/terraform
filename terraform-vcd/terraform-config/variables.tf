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
  test35 = var.vdcName == "wdc-vcd05-CorpITTest-t-Test35-ovdc1" ? "wdc-vcd05-CorpITTest-t-o51": ""
  test41 = var.vdcName == "wdc-vcd05-CorpITTest-t-Test41-ovdc" ? "wdc-vcd05-CorpITTest-t-Tes41-o11": ""
  uat2 = var.vdcName == "wdc-vcd05-CorpITTest-t-UAT2-ovdc4" ? "wdc-vcd05-CorpITTest-t-UAT2-o41": ""
  test12 = var.vdcName == "wdc-vcd05-CorpITTest-t-Test12-ovdc6" ? "wdc-vcd05-CorpITTest-t-Test12-o61": ""
  test31 = var.vdcName == "wdc-vcd05-CorpITTest-t-Test31-ovdc1" ? "wdc-vcd05-CorpITTest-t-Test31-o11": ""
  test_ias = var.vdcName == "wdc-vcd05-CorpITTest-t-WL-iAS-ovdc3" ? "wdc-vcd05-CorpITTest-t-WL-iAS-o31": ""
  test50 = var.vdcName == "wdc-vcd05-CorpITDev-t-Test50-ovdc1" ? "wdc-vcd05-CorpITDev-t-o62" : ""
  test11 = var.vdcName == "wdc-vcd05-CorpITDev-t-Test11-ovdc8" ? "wdc-vcd05-CorpITDev-t-Test11-o81" : ""
  dev15 = var.vdcName == "wdc-vcd05-CorpITDev15-t-ovdc1" ? "wdc-vcd05-CorpITDev-t-o11": ""
  test15 = var.vdcName == "wdc-vcd05-CorpITDev-t-Test15-ovdc1" ? "wdc-vcd05-CorpITDev-t-o31": ""
  uat1 = var.vdcName == "wdc-vcd05-CorpITDev-t-UAT1-ovdc9" ? "wdc-vcd05-CorpITDev-t-UAT1-o91" : ""
  dev12 = var.vdcName == "wdc-vcd05-CorpITDev-t-Dev12-ovdc1" ? "wdc-vcd05-CorpITDev-t-o51": ""
  dev_ias = var.vdcName == "wdc-vcd05-CorpITDev-t-WL-iAS-ovdc7" ? "wdc-vcd05-CorpITDev-t-WL-iAS-o71": ""
  nonsdlc = var.vdcName=="wdc-vcd05-NonSDLC-DevOps-t-ovdc2" ? "wdc-vcd05-NonSDLC-DevOps-t-o22" : ""
  org_network=coalesce(local.test35,local.test41,local.uat2,local.test12,local.test31,local.test_ias,local.test50,local.test11,local.dev15,local.test15,local.uat1,local.dev12,local.dev_ias,local.nonsdlc)
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
variable "blueprint" {
    type = string
}
variable "patch" {
    type = string
}