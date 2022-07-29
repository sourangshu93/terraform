terraform {
  required_providers {
    avi = {
      source = "vmware/avi"
      version = "20.1.4"
    }
    infoblox = {
      source = "infobloxopen/infoblox"
      version = "2.0.1"
    }
  }
}

provider "avi" {
  avi_username = "ksourangshu"
  avi_tenant = var.tenant
  avi_password = "Password"
  avi_controller = "avi-controller-eat1.vmware.com"
  avi_version = "20.1.4"
} 
provider "infoblox" {
    username = "ksourangshu"
    password = "Password"
    server = "10.166.16.127"
    sslmode = false
}