terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.0.2"
    }
    infoblox = {
      source = "infobloxopen/infoblox"
      version = "2.0.1"
    }
  }
}
provider "vsphere" {
  user           = "svc.devopsapi@vmware.com"
  password       = "gZ@Bp9NGCb^i!^q323^"
  vsphere_server = "wdc-01-vc14.oc.vmware.com"
  allow_unverified_ssl = true
}
provider "infoblox" {
    username = "svc.devopsapi"
    password = "gZ@Bp9NGCb^i!^q323^"
    server = "10.166.16.127"
    sslmode = false
}