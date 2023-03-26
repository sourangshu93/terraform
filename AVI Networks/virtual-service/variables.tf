variable "tenant" {
    description = "The tenant where the AVI Virtual service need to be deployed"
    type = string
}
variable "vs_name" {
    description = "The virtual service name"
    type = string
}
variable "load_balance" {
    description = "Select appropriate load balancing algorithm"
    type = string
    validation {
      condition = can(["Round Robin","Least Load"],var.load_balance)
      error_message = "Load balance alogorithm can be one of [\"Round Robin\",\"Least Load\"]"
    }
}
variable "service_port" {
  description = "Provide the load balancer service port number"
  type = number
}
variable "cloud" {
  type = string
  description = "Provide the cloud name where to deploy the virtual service"
}
variable "vrf" {
  type = string
  description = "Provide the VRF name where to deploy the virtual service"
}
variable "seg" {
  type = string
  description = "Provide the name of service engineering group"
}
variable "cidr" {
  type = string
  description = "Provide the CIDR for the virtual service to deploy"
}
variable "ip_address" {
  type = list(string)
  description = "Provide the list of backend servers"
}