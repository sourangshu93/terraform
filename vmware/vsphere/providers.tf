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
  user           = "user"
  password       = "Password"
  vsphere_server = "wdc-01-vc14.oc.vmware.com"
  allow_unverified_ssl = true
}
provider "infoblox" {
    username = "user"
    password = "Password"
    server = "10.166.16.127"
    sslmode = false
}