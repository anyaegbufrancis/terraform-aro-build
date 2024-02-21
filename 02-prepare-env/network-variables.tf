variable "aro_virtual_network_cidr_block" {
  type        = string
  description = "cidr range for aro virtual network"
}
variable "aro_control_subnet_cidr_block" {
  type        = string
  description = "cidr range for aro control plane subnet"
}
variable "aro_worker_subnet_cidr_block" {
  type        = string
  description = "cidr range for aro machine subnet"
}
variable "aro_firewall_subnet_cidr_block" {
  type        = string
  description = "cidr range for Azure Firewall virtual network"
}
locals {
  vnet_name                 = "${var.resource_group_name}-vnet"
  control_plane_subnet_name = "${var.resource_group_name}-cp-subnet"
  worker_nodes_subnet_name  = "${var.resource_group_name}-machine-subnet"
  vnet_resource_group       = "${var.resource_group_name}-vnet-rg"
}