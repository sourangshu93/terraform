terraform {
  required_providers {
    vcd = {
      source = "vmware/vcd"
      version = "3.4.0"
    }
    infoblox = {
      source = "infobloxopen/infoblox"
      version = "2.0.1"
    }
  }
}
provider "vcd" {
    user                 = var.vcdUser
    password             = var.vcdPassword
    auth_type            = "integrated" 
    org                  = var.orgName
    vdc                  = var.vdcName
    url                  = var.orgUrl
    max_retry_timeout    = "60"
    allow_unverified_ssl = "true"
}
provider "infoblox" {
    username = var.infoblox_username
    password = var.infoblox_password
    server = "infoblox.example.com"
    sslmode = false
}
