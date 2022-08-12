data "vsphere_datacenter" "dc" {
  name = "Datacenter"
}
data "vsphere_datastore" "datastore" {
  name          = "VSANDatastore-Poc-VC"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
data "vsphere_compute_cluster" "cluster" {
  name          = "Poc-VC-cl1"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
data "vsphere_network" "network" {
  name          = "Poc-VC--10.24.88.0-22"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "std-oel7-tmpl"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
/* resource "vsphere_tag_category" "tag-environment" {    
  name             = "Environment"    
  cardinality      = "SINGLE"
  associable_types = [        
    "VirtualMachine"    
  ]
}  */
/* resource "vsphere_tag" "tag-environment-poc" {    
  name        = "poc-vm"    
  category_id = "${vsphere_tag_category.tag-environment.id}"
  description = "POC Environment"
}  */
/* data "vsphere_tag_category" "tag-network"{
  name = "Network"
} */
/* data "vsphere_tag" "tag-environment-vc" {
  name  = "Promb"
  category_id = data.vsphere_tag_category.tag-network.id
} */
resource "vsphere_virtual_machine" "vm-primary" {
  name = "${var.vm_name}1"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  num_cpus         = 2
  memory           = 4096
  guest_id         = "${data.vsphere_virtual_machine.template.guest_id}"
  scsi_type        = "${data.vsphere_virtual_machine.template.scsi_type}"
  scsi_controller_count = 3
  annotation       = "Application: Linux POC VM \nOwner: Sourangshu Kundu \nOwner DL: sourangshu04@gmail.com"
  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }
  disk {
    label = "boot_disk"
    size  = 40
  }
  disk {
    label        = "DATA"
    size         = 10
    unit_number  = 16
    disk_mode    = "independent_persistent"
    disk_sharing = "sharingMultiWriter"
  }
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    customize {
      linux_options {
        host_name = "${var.vm_name}1"
        domain    = "infra-dev.example.com"
      }
      network_interface {}
    }
  }
}
resource "infoblox_ipv4_allocation" "allocation-primary" {
    network_view = "default"
    dns_view     = "default"
    ip_addr      = vsphere_virtual_machine.vm-primary.default_ip_address
    fqdn         = "${vsphere_virtual_machine.vm-primary.name}.infra-dev.example.com"
    enable_dns   = true
    enable_dhcp  = false
}
resource "vsphere_virtual_machine" "vm" {
  count            = "${var.vm_count}"-1
  name             = "${var.vm_name}${count.index+2}"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  num_cpus         = 2
  memory           = 4096
  guest_id         = "${data.vsphere_virtual_machine.template.guest_id}"
  scsi_type        = "${data.vsphere_virtual_machine.template.scsi_type}"
  scsi_controller_count = 3
  annotation       = "Application: Oracle RAC VM \nOwner: Sourangshu Kundu \nOwner DL: sourangshu04@gmail.com"
  #tags             = [ "${vsphere_tag.tag-environment-poc.id}","${data.vsphere_tag.tag-environment-vc.id}" ]
  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }
  disk {
    label = "boot_disk"
    size  = 40
  }
  disk {
    label        = "DATA"
    attach       = true
    path         = "${vsphere_virtual_machine.vm-primary.name}/${vsphere_virtual_machine.vm-primary.name}_1.vmdk"
    unit_number  = 16
    datastore_id = data.vsphere_datastore.datastore.id
    disk_mode    = "independent_persistent"
    disk_sharing = "sharingMultiWriter"
  }
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    customize {
      linux_options {
        host_name = "${var.vm_name}${count.index+2}"
        domain    = "infra-dev.example.com"
      }
      network_interface {}
    }
  }
}
resource "infoblox_ipv4_allocation" "allocation1" {
    count        = "${var.vm_count}"-1
    network_view = "default"
    dns_view     = "default"
    ip_addr      = vsphere_virtual_machine.vm[count.index].default_ip_address
    fqdn         = "${vsphere_virtual_machine.vm[count.index].name}.infra-dev.example.com"
    enable_dns   = true
    enable_dhcp  = false
  provisioner "file" {
  source      = "OracleLinux-7.repo"
  destination = "/etc/yum.repos.d/OracleLinux-7.repo"
  }
  connection {
    type     = "ssh"
    user     = "root"
    password = "redhat"
    host     = vsphere_virtual_machine.vm[count.index].default_ip_address
  }
  /* provisioner "remote-exec" {
    inline= [  
      "echo -e 'Hello User,\n\nVM build has been completed please find the build details.\nVM Name: ${vsphere_virtual_machine.vm.name}\nIP Address: ${vsphere_virtual_machine.vm.default_ip_address}\nFQDN: ${infoblox_ipv4_allocation.allocation1.fqdn}\nNo of CPUs:${vsphere_virtual_machine.vm.num_cpus}\nTotal Memory: ${vsphere_virtual_machine.vm.memory} MB\nReach out to sourangshu04 for any issue.\n\nRegards,\nSourangshu'| mail  -s 'VM build completed for vm ${vsphere_virtual_machine.vm.name}' -r terraform@gmail.com sourangshu04@gmail.com"
    ]
  connection {
    type     = "ssh"
    user     = "root"
    password = "redhat"
    host     = "centos-poc-lab1.infra-dev.example.com"
  }
  }  */
}
