data "avi_tenant" "nsxalb_tenant"{
    name = var.tenant
}
data "avi_cloud" "nsxalb_cloud" {
    name = var.cloud
}
data "avi_vrfcontext" "nsxalb_vrf" {
    name = var.vrf
    cloud_ref = data.avi_cloud.nsxalb_cloud.id
}
data "avi_serviceenginegroup" "nsxalb_se" {
    name = var.seg
}
data "avi_healthmonitor" "nsxalb_monitor" {
  name = "TCP-120"
  tenant_ref = data.avi_tenant.nsxalb_tenant.id
}
data "avi_applicationprofile" "nsxalb_appprofile" {
  name = "System-HTTP"
  tenant_ref = data.avi_tenant.nsxalb_tenant.id
}
data "avi_networkprofile" "nsxalb_netprofile" {
  name = "tcp"
  tenant_ref = data.avi_tenant.nsxalb_tenant.id
}
resource "infoblox_ipv4_allocation" "vs_ip_allocation" {
    network_view = "default"
    dns_view = "default"
    cidr = var.cidr
    fqdn = "${var.vs_name}-vip.domain.com"
    enable_dns = true
    enable_dhcp = false
}
resource "avi_vsvip" "nsxalb_vip" {
    name = "${var.vs_name}-vip"
    cloud_ref = data.avi_cloud.nsxalb_cloud.id
    tenant_ref = data.avi_tenant.nsxalb_tenant.id
    vrf_context_ref= data.avi_vrfcontext.nsxalb_vrf.id
    vip {
      vip_id= "0"
      ip_address {
         addr = infoblox_ipv4_allocation.vs_ip_allocation.ip_addr
         type = "V4"
        }
    }
}
resource "avi_pool" "nsxalb_pool" {
  name= "${var.vs_name}-vip-pool"
  health_monitor_refs   = [data.avi_healthmonitor.nsxalb_monitor.id]
  tenant_ref            = data.avi_tenant.nsxalb_tenant.id
  cloud_ref             = data.avi_cloud.nsxalb_cloud.id
  vrf_ref               = data.avi_vrfcontext.nsxalb_vrf.id
  default_server_port   = 80
  lb_algorithm          = local.lb
  application_persistence_profile_ref= "${avi_applicationpersistenceprofile.test_applicationpersistenceprofile.id}"
  servers {
      ip {
          type = "V4"
          addr = var.ip_address[0]
        }
    }
  servers {
      ip {
          type = "V4"
          addr = var.ip_address[1]
      }
  }
}
resource "avi_virtualservice" "nsxalb-vs" {
    name                    = "${var.vs_name}-vip"
    vrf_context_ref         = data.avi_vrfcontext.nsxalb_vrf.id
    cloud_ref               = data.avi_cloud.nsxalb_cloud.id
    tenant_ref              = data.avi_tenant.nsxalb_tenant.id
    se_group_ref            = data.avi_serviceenginegroup.nsxalb_se.id
    pool_ref                = avi_pool.nsxalb_pool.id
    traffic_enabled         = true
    vsvip_ref               = avi_vsvip.nsxalb_vip.id
    application_profile_ref = data.avi_applicationprofile.nsxalb_appprofile.id
    network_profile_ref     = data.avi_networkprofile.nsxalb_netprofile.id
    description             = "Created using Terraform"
    services {
      port = var.service_port
   }
}
resource "infoblox_cname_record" "vip_cname_record"{
  dns_view = "default"
  canonical = "${var.vs_name}-vip.domain.com"
  alias = "${var.vs_name}.domain.com"
  ttl = 3600

  comment = "Test CNAME record from Terraform"
  ext_attrs = jsonencode({
     "Tracking ID" = "Terraform Managed"
  })
}