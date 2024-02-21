
## Conditionally create or update VNETs or Subnets
resource "azurerm_virtual_network" "main_vnet" {
  name                = local.vnet_name
  location            = var.location
  resource_group_name = local.vnet_resource_group
  address_space       = [var.aro_virtual_network_cidr_block]
  tags                = var.tags
  depends_on = [ 
    azurerm_resource_group.vnet_rg, 
    azurerm_resource_group.main_rg, 
    azurerm_resource_group.fw_rg
  ]
}

resource "azurerm_virtual_network" "fw_vnet" {
  count                = var.restrict_egress ? 1 : 0
  name                = "${var.fw_rg}-vnet"
  location            = var.location
  resource_group_name = var.fw_rg
  address_space       = [var.aro_firewall_subnet_cidr_block]
  tags                = var.tags
  depends_on = [ 
    azurerm_resource_group.vnet_rg, 
    azurerm_resource_group.main_rg, 
    azurerm_resource_group.fw_rg
  ]
}

# TODO: Convert from Non Hub-Spoke to Hub-Spoke model (split vNETs)
resource "azurerm_subnet" "firewall_subnet" {
  count                = var.restrict_egress ? 1 : 0
  name                 = "${var.fw_rg}-subnet"
  resource_group_name  = var.fw_rg
  virtual_network_name = "${var.fw_rg}-vnet"
  address_prefixes     = [var.aro_firewall_subnet_cidr_block]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.ContainerRegistry"]
}

resource "azurerm_subnet" "control_plane_subnet" {
  name                                          = local.control_plane_subnet_name
  resource_group_name                           = local.vnet_resource_group
  virtual_network_name                          = local.vnet_name
  address_prefixes                              = [var.aro_control_subnet_cidr_block]
  service_endpoints                             = ["Microsoft.Storage", "Microsoft.ContainerRegistry"]
  private_link_service_network_policies_enabled = true
  private_endpoint_network_policies_enabled     = true
  depends_on = [ 
    azurerm_virtual_network.main_vnet, 
    azurerm_resource_group.main_rg
  ]
}

resource "azurerm_subnet" "machine_subnet" {
  name                 = local.worker_nodes_subnet_name
  resource_group_name  = local.vnet_resource_group
  virtual_network_name = local.vnet_name
  address_prefixes     = [var.aro_worker_subnet_cidr_block]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.ContainerRegistry"]
  depends_on = [ 
    azurerm_virtual_network.main_vnet, 
    azurerm_resource_group.main_rg
  ]
}