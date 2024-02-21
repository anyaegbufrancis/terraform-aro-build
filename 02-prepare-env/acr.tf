# Azure Container Registry (ACR) in Private ARO Clusters
# https://learn.microsoft.com/en-us/azure/container-registry/container-registry-private-link

resource "azurerm_subnet" "private_endpoint_subnet" {
  count                                     = var.create_acr ? 1 : 0
  name                                      = var.acr_private_endpoint_subnet_name
  resource_group_name                       = local.resource_group_name
  virtual_network_name                      = local.vnet_name
  address_prefixes                          = [var.aro_private_endpoint_cidr_block]
  private_endpoint_network_policies_enabled = false
}

## Register ACR Provider
resource "azurerm_resource_provider_registration" "acr" {
  count = var.create_acr ? 1 : 0
  name  = "Microsoft.ContainerRegistry"
}

resource "azurerm_private_dns_zone" "dns" {
  count               = var.create_acr ? 1 : 0
  name                = var.acr_dns_endpoint_name
  resource_group_name = local.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_link" {
  count                 = var.create_acr ? 1 : 0
  name                  = var.acr_private_dns_zone_virtual_link_name
  resource_group_name   = local.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dns.0.name
  virtual_network_id    = azurerm_virtual_network.main_vnet.id
  registration_enabled  = false
}

resource "random_string" "acr" {
  length      = 4
  min_numeric = 4
  keepers = {
    name = "acraro"
  }
}

resource "azurerm_container_registry" "acr" {
  count                         = var.create_acr ? 1 : 0
  name                          = local.acr_container_registry_name
  location                      = var.location
  resource_group_name           = local.resource_group_name
  sku                           = "Premium"
  admin_enabled                 = true
  public_network_access_enabled = false
}

resource "azurerm_private_endpoint" "acr" {
  count               = var.create_acr ? 1 : 0
  name                = var.acr_private_endpoint_name
  location            = var.location
  resource_group_name = local.resource_group_name
  subnet_id           = azurerm_subnet.private_endpoint_subnet.0.id

  private_dns_zone_group {
    name = "acr-zonegroup"
    private_dns_zone_ids = [
      azurerm_private_dns_zone.dns.0.id
    ]
  }

  private_service_connection {
    name                           = "acr-connection"
    private_connection_resource_id = azurerm_container_registry.acr.0.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }
}

