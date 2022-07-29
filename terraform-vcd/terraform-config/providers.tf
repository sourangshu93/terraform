terraform {
  required_providers {
    vcd = {
      source = "vmware/vcd"
      version = "3.4.0"
    }
    infoblox = {
      source = "infobloxopen/infoblox"
      version = "2.1.0"
    }
  }
}
