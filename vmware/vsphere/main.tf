data "vsphere_datacenter" "dc" {
  name = "wdc-01-vc14"
}
data "vsphere_datastore" "datastore" {
  name          = "wdc-01-vc14c02-vsan"
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_compute_cluster" "cluster" {
  name          = "wdc-01-vc14c02"
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_network" "network" {
  name          = "wdc-01-vc14-n2-t"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.template
  datacenter_id = data.vsphere_datacenter.dc.id
}
resource "vsphere_virtual_machine" "vm" {
  name             = var.vm_name
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus = var.vcpu
  memory   = var.memory
  guest_id = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type
  scsi_controller_count = 1
  annotation = "Application Owner/DL: \nApplication Name: \nHelpNow(#) : \n(Server deployed using Terraform)"
  network_interface {
    network_id = data.vsphere_network.network.id
  }
  disk {
    label = "boot_disk"
    size  = 40
  }
  disk {
    label = "DATA"
    size = var.disk_size1
    unit_number = 2
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = var.vm_name
        domain    = "vmware.com"
      }
      network_interface {}
    }
  }
}
resource "infoblox_ipv4_allocation" "allocation1" {
  network_view = "default"
  dns_view = "default"
  ip_addr = vsphere_virtual_machine.vm.default_ip_address
  fqdn = "${vsphere_virtual_machine.vm.name}.vmware.com"
  enable_dns = true
  enable_dhcp = false
  comment = "Deployed from Terraform"
  provisioner "remote-exec" {
    inline= [  
      "echo -e 'Hello User,\n\nVM build has been completed please find the build details.\nVM Name: ${vsphere_virtual_machine.vm.name}\nIP Address: ${vsphere_virtual_machine.vm.default_ip_address}\nFQDN: ${infoblox_ipv4_allocation.allocation1.fqdn}\nNo of vCPUs: ${vsphere_virtual_machine.vm.num_cpus}\nTotal Memory: ${vsphere_virtual_machine.vm.memory} MB\nReach out to DevOps Linux Team <it-devops-linuxsa@vmware.com> for any issue.\n\nRegards,\nDevOps Linux Team'| mail  -s 'VM build completed for vm ${vsphere_virtual_machine.vm.name}' -r terraform@vmware.com ksourangshu@vmware.com"
    ]
  connection {
    type     = "ssh"
    user     = "root"
    password = "redhat"
    host     = "centos-poc-lab1.infra-dev.vmware.com"
  }
}
}