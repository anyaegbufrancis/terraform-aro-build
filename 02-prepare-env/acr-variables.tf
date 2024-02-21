variable "aro_private_endpoint_cidr_block" {
  type        = string
  description = "cidr range for Azure Firewall virtual network"
}

variable "acr_private_endpoint_subnet_name" {
  type        = string
  description = "Private Endpoint subnet name"
}

variable "acr_private_dns_zone_virtual_link_name" {
  type        = string
  description = "Private Endpoint DNS virtual link name"
}

variable "acr_dns_endpoint_name" {
  type        = string
  description = "Private Endpoint private dns zone name"
}

variable "acr_private_endpoint_name" {
  type        = string
  description = "Private Endpoint name"
}

locals {
  acr_container_registry_name = "acraro${random_string.acr.result}"
}