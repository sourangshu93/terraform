variable "tenant" {
    type = string
}
variable "vs_name" {
    type = string
}
variable "load_balance" {
    type = string
}
locals {
  lb1 = var.load_balance == "Round Robin" ? "LB_ALGORITHM_ROUND_ROBIN" : ""
  lb2 = var.load_balance == "Least Load" ? "LB_ALGORITHM_LEAST_LOAD" : ""
  lb = coalesce(local.lb1,local.lb2)
}
variable "service_port" {
    type = number
}
