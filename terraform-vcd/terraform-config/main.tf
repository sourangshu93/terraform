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
resource "vcd_vapp" "terraform_vapp" {
  name = "${var.vm_name}-Vapp"
}
resource "vcd_vapp_org_network" "vappOrgNet" {
  vapp_name = vcd_vapp.terraform_vapp.name
  org_network_name = local.org_network
}
resource "vcd_vapp_vm" "terraform_vm" {
  vapp_name              = vcd_vapp.terraform_vapp.name
  name                   = var.vm_name
  computer_name          = var.vm_name
  catalog_name           = "linux_sddc_templates"
  template_name          = var.template_name
  description            = "VM Deployed from Terraform"
  memory                 = var.memory
  memory_hot_add_enabled = true
  cpus                   = var.cpu
  cpu_cores              = 1
  cpu_hot_add_enabled    = true
  network {
    type               = "org"
    name               = vcd_vapp_org_network.vappOrgNet.org_network_name
    adapter_type       = "VMXNET3"
    ip_allocation_mode = "POOL"
    is_primary         = true
  }
}
resource "vcd_vm_internal_disk" "disk1" {
  count = var.additional_disk=="Yes" ? 1 : 0
  vapp_name       = vcd_vapp.terraform_vapp.name
  vm_name         = vcd_vapp_vm.terraform_vm.name
  bus_type        = var.template_name=="std-oel7-tmpl-2022" ? "parallel" : "paravirtual"
  size_in_mb      = var.disk_size_in_mb
  bus_number      = 0
  unit_number     = 4
  depends_on      = [vcd_vapp_vm.terraform_vm]
}
provider "infoblox" {
    username = "svc.devopsapi"
    password = "gZ@Bp9NGCb^i!^q323^"
    server = "10.166.16.127"
    sslmode = false
}
resource "infoblox_ipv4_allocation" "allocation1" {
    network_view = "default"
    dns_view = "default"
    ip_addr = vcd_vapp_vm.terraform_vm.network[0].ip
    fqdn = "${vcd_vapp_vm.terraform_vm.name}.vmware.com"
    enable_dns = true
    comment = "IP Allocated from Terraform"
  provisioner "remote-exec" {
    inline= [  
      "echo -e 'Hello User,\n\nVM build has been completed please find the details below.\nVM Name: ${vcd_vapp_vm.terraform_vm.name}\nIP Address: ${vcd_vapp_vm.terraform_vm.network[0].ip}\nFQDN: ${infoblox_ipv4_allocation.allocation1.fqdn}\nNo of CPUs: ${vcd_vapp_vm.terraform_vm.cpus}\nTotal Memory: ${vcd_vapp_vm.terraform_vm.memory} MB\nReach out to DevOps Linux Team <it-devops-linuxsa@vmware.com> for any issue.\n\nRegards,\nDevOps Linux Team'| mail  -s 'VM build completed for vm ${vcd_vapp_vm.terraform_vm.name}' -r terraform@vmware.com ksourangshu@vmware.com kkumarbutta@vmware.com"
    ]
  connection {
    type     = "ssh"
    user     = "root"
    password = "redhat"
    host     = "centos-poc-lab1.infra-dev.vmware.com"
  }
}
}