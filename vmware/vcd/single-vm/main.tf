resource "vcd_vapp" "test-vapp" {
  name = "ubuntu-poc-app1-Vapp"
}
resource "vcd_vapp_org_network" "vappOrgNet" {
  vapp_name = vcd_vapp.test-vapp.name
  org_network_name = local.ovdc_network
}
resource "vcd_vapp_vm" "test-vm" {
  vapp_name              = vcd_vapp.test-vapp.name
  name                   = "ubuntu-poc-app1"
  computer_name          = "ubuntu-poc-app1"
  catalog_name           = "linux_sddc_templates"
  template_name          = var.template_name
  description            = "Application: Application Server \nOwner: Sourangshu \nOwner DL: souranghsu04@gmail.com"
  memory                 = 4096
  memory_hot_add_enabled = false
  cpus                   = 2
  cpu_cores              = 1
  cpu_hot_add_enabled    = false
  hardware_version       = "vmx-18"
#  guest_properties = {
#    "guest.hostname" = "ubun-poc-app1"
#    "guest.network" = vcd_vapp_org_network.vappOrgNet.ip
#  } 
  /*customization {
    force                      = true
    change_sid                 = true
    allow_local_admin_password = true
    auto_generate_password     = false
    admin_password             = "redhat"
  }*/
  network {
    type               = "org"
    name               = vcd_vapp_org_network.vappOrgNet.org_network_name
    adapter_type       = "VMXNET3"
    ip_allocation_mode = "POOL"
    is_primary         = true
  }
}
resource "vcd_vm_internal_disk" "disk1" {
  count = 1
  vapp_name       = vcd_vapp.test-vapp.name
  vm_name         = vcd_vapp_vm.test-vm.name
  bus_type        = var.template_name=="std-oel7-tmpl-2022" || var.template_name=="std-ubuntu-tmpl-2022" ? "parallel" : "paravirtual"
  size_in_mb      = 2150400
  bus_number      = 0
  unit_number     = 3
  depends_on      = [vcd_vapp_vm.test-vm]
}

resource "infoblox_ipv4_allocation" "allocation1" {
    network_view = "default"
    dns_view     = "default"
    ip_addr      = vcd_vapp_vm.test-vm.network[0].ip
    fqdn         = "${vcd_vapp_vm.test-vm.name}.infra-dev.example.com"
    enable_dns   = true
    enable_dhcp  = false
  provisioner "remote-exec" {
    inline= [  
      "echo -e 'Hello User,\n\nVM build has been completed please find the build details.\nVM Name: ${vcd_vapp_vm.test-vm.name}\nIP Address: ${vcd_vapp_vm.test-vm.network[0].ip}\nFQDN: ${infoblox_ipv4_allocation.allocation1.fqdn}\nNo of CPUs: ${vcd_vapp_vm.test-vm.cpus}\nTotal Memory: ${vcd_vapp_vm.test-vm.memory} MB\nReach out to souranghsu04@gmail.com for any issue.\n\nRegards,\nSourangshu'| mail  -s 'VM build completed for vm ${vcd_vapp_vm.test-vm.name}' -r automation@gmail.com souranghsu04@gmail.com"
    ]
  connection {
    type     = "ssh"
    user     = "root"
    password = "redhat"
    host     = "centos-poc-lab1.infra-dev.exaple.com"
  }
}
}