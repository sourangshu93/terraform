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
  name          = "Poc-VC-10.24.88.0-22"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "std-oel7-tmpl"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
resource "vsphere_tag_category" "application" {    
  name             = "OracleDB"    
  cardinality      = "SINGLE"
  associable_types = [        
    "VirtualMachine"    
  ]
}
resource "vsphere_tag" "tag1" {    
  name        = "Application"    
  category_id = "${vsphere_tag_category.application.id}"
  description = "Oracle Database 19c"
}
data "vsphere_tag_category" "tag-server"{
  name = "Network"
}
data "vsphere_tag" "tag2" {
  name  = "Poc0-VC"
  category_id = data.vsphere_tag_category.tag-server.id
}
resource "vsphere_virtual_machine" "vm" {
  name             = "${var.vm_name}"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  num_cpus         = 4
  memory           = 8192
  guest_id         = "${data.vsphere_virtual_machine.template.guest_id}"
  scsi_type        = "${data.vsphere_virtual_machine.template.scsi_type}"
  scsi_controller_count = 1
  annotation       = "Application: Oracle Linux \nOwner: Souranghsu \nOwner DL: sourangshu04@gmail.com"
  tags             = [ "${vsphere_tag.tag1.id}","${data.vsphere_tag.tag2.id}" ]
  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }
  
  disk {
    label = "boot_disk"
    size  = 40
  }
  disk {
    label = "swap"
    size = 6
    unit_number = 2
  }
  disk {
    label       = "oracle"
    size        = 20
    unit_number = 3
  }
  disk {
    label       = "oradata"
    size        = 20
    unit_number = 4
  }
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    
    customize {
      linux_options {
        host_name = var.vm_name
        domain    = "infra-dev.example.com"
      }
      network_interface {}
    }
  }
}
resource "infoblox_ipv4_allocation" "allocation1" {
    network_view = "default"
    dns_view     = "default"
    ip_addr      = vsphere_virtual_machine.vm.default_ip_address
    fqdn         = "${vsphere_virtual_machine.vm.name}.infra-dev.example.com"
    enable_dns   = true
    enable_dhcp  = false
  provisioner "remote-exec" {
    inline = [
      " rm -rf /etc/yum.repos.d/*"
    ]
  }
  provisioner "file" {
  source      = "OracleLinux-7.repo"
  destination = "/etc/yum.repos.d/OracleLinux-7.repo"
  }
  provisioner "remote-exec" {
    inline = [
      "yum clean all",
      "yum update -y",
      "rpm --import https://repo.saltproject.io/py3/redhat/7/x86_64/latest/SALTSTACK-GPG-KEY.pub",
      "curl -fsSL https://repo.saltproject.io/py3/redhat/7/x86_64/latest.repo | sudo tee /etc/yum.repos.d/salt.repo",
      "yum install salt-minion -y",
      "sed -i 's/#master: salt/master: saltmaster1.example.com/g' /etc/salt/minion",
      "systemctl enable salt-minion && sudo systemctl start salt-minion"
    ]
  }
  connection {
    type     = "ssh"
    user     = "root"
    password = "redhat"
    host     = vsphere_virtual_machine.vm.default_ip_address
  }
  provisioner "remote-exec" {
    inline= [  
      "echo -e 'Hello User,\n\nVM build has been completed please find the build details.\nVM Name: ${vsphere_virtual_machine.vm.name}\nIP Address: ${vsphere_virtual_machine.vm.default_ip_address}\nFQDN: ${infoblox_ipv4_allocation.allocation1.fqdn}\nNo of vCPUs: ${vsphere_virtual_machine.vm.num_cpus}\nTotal Memory: ${vsphere_virtual_machine.vm.memory} MB\nReach out to souranghsu04@gmail.com for any issue.\n\nRegards,\nSourangshu'| mail  -s 'VM build completed for vm ${vsphere_virtual_machine.vm.name}' -r terraform@gmail.com sourangshu04@gmail.com"
    ]
  connection {
    type     = "ssh"
    user     = "root"
    password = "redhat"
    host     = "centos-poc-lab1.infra-dev.example.com"
  }
  } 
}
