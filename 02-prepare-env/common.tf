# Create Resource Group
resource "azurerm_resource_group" "main_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_resource_group" "vnet_rg" {
  name     = local.aro-vnet-rg
  location = var.location
}

resource "azurerm_resource_group" "fw_rg" {
  name     = var.fw_rg
  location = var.location
}

resource "azurerm_resource_provider_registration" "reddhatopenshift" {
  count = var.install_providers ? 1 : 0
  name  = "Microsoft.RedHatOpenShift"
}

resource "azurerm_resource_provider_registration" "microsoftcompute" {
  count = var.install_providers ? 1 : 0
  name  = "Microsoft.Compute"
}

resource "azurerm_resource_provider_registration" "microsoftstorage" {
  count = var.install_providers ? 1 : 0
  name  = "Microsoft.Storage"
}

resource "azurerm_resource_provider_registration" "microsoftauth" {
  count = var.install_providers ? 1 : 0
  name  = "Microsoft.Authorization"
}

