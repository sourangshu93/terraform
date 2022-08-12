output "virtual_service_name" {
  value = avi_virtualservice.nsxalb-vs.name
}
output "virtual_service_ip" {
  value = infoblox_ipv4_allocation.vs_ip_allocation.ip_addr
}
output "virtual_service_address" {
    value = "${avi_virtualservice.nsxalb-vs.name}.vmware.com"
}