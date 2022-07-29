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
    user                 = "local.vra"
    password             = "local.vra"
    auth_type            = "integrated" 
    org                  = var.orgName
    vdc                  = var.vdcName
    url                  = "https://wdc-vcd05.oc.vmware.com/api"
    max_retry_timeout    = "60"
    allow_unverified_ssl = "true"
}
provider "infoblox" {
    username = "svc.devopsapi"
    password = "gZ@Bp9NGCb^i!^q323^"
    server = "10.166.16.127"
    sslmode = false
}