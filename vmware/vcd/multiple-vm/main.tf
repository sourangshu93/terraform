resource "vcd_vapp" "test-vapp" {
  count = var.vm_count
  name = "${var.vm_name}${count.index+1}-Vapp"
}
resource "vcd_vapp_org_network" "vappOrgNet" {
  count = var.vm_count
  vapp_name = "${var.vm_name}${count.index+1}-Vapp" #vcd_vapp.test-vapp.name
  org_network_name = "poc-vcd05-Sandbox-t-o11"
  depends_on      = [vcd_vapp.test-vapp]
}
resource "vcd_vapp_vm" "test-vm" {
  count                  = var.vm_count
  vapp_name              = "${var.vm_name}${count.index+1}-Vapp" # vcd_vapp.test-vapp.name
  name                   = "${var.vm_name}${count.index+1}"
  computer_name          = "${var.vm_name}${count.index+1}"
  catalog_name           = "linux_sddc_templates"
  template_name          = "std-ubuntu-tmpl-2022"
  description            = "Application: Application Server \nOwner: Sourangshu \nOwner DL: souranghsu04@gmail.com"
  memory                 = 4096
  memory_hot_add_enabled = false
  cpus                   = 2
  cpu_cores              = 1
  cpu_hot_add_enabled    = false
  hardware_version       = "vmx-18"

  network {
    type               = "org"
    name               = "${vcd_vapp_org_network.vappOrgNet[count.index].org_network_name}"
    adapter_type       = "VMXNET3"
    ip_allocation_mode = "POOL"
    is_primary         = true
  }
  depends_on      = [vcd_vapp.test-vapp]
}
/* resource "vcd_vm_internal_disk" "disk1" {
  count = 1
  vapp_name       = vcd_vapp.test-vapp.name
  vm_name         = "${vcd_vapp_vm.test-vm[count.index].name}"
  bus_type        = "parallel"
  size_in_mb      = 10240
  bus_number      = 0
  unit_number     = 3
  depends_on      = [vcd_vapp_vm.test-vm]
} */

resource "infoblox_ipv4_allocation" "allocation1" {
    count        = "${var.vm_count}"
    network_view = "default"
    dns_view     = "default"
    ip_addr      = "${vcd_vapp_vm.test-vm[count.index].network[0].ip}"
    fqdn         = "${vcd_vapp_vm.test-vm[count.index].name}.infra-dev.example.com"
    enable_dns   = true
    enable_dhcp  = false
}