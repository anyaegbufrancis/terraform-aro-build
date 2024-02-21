variable "resource_group_name" {
  description = "ARO Resource Group name"
}

variable "fw_rg" {
  description = "FW Resource Group name"
}

locals {
  resource_group_name = var.resource_group_name
  aro-vnet-rg         = "${var.resource_group_name}-vnet-rg"
}


variable "tags" {
  type = map(string)
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID (needed with the new Auth method)"
}

