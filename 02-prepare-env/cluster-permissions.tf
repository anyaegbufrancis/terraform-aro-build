# data "azuread_application" "read_cluster_sp" {
#   display_name = "api://openenv-qnxk4"
# }

# resource "azurerm_role_assignment" "cluster_sp_client" {
#   scope                = azurerm_resource_group.main_rg.id
#   role_definition_name = "Contributor"
#   principal_id         = data.azuread_application.read_cluster_sp.object_id
#   depends_on           = [ azurerm_resource_group.main_rg ]
# }


## Assign Network Contributor to ARO RP SP
data "azuread_service_principal" "aro_resource_provisioner" {
  display_name = "Azure Red Hat OpenShift RP"
}

# data "azurerm_resource_group" "rg_read" {
#   name = local.aro-vnet-rg
# }

resource "azurerm_role_assignment" "aro_rp_sp_assign" {
  scope                = azurerm_virtual_network.main_vnet.id 
  role_definition_name = azurerm_role_definition.network_contributor_alt.name
  principal_id         = data.azuread_service_principal.aro_resource_provisioner.object_id
  depends_on           = [ azurerm_role_definition.network_contributor_alt ]
}

resource "azurerm_role_definition" "network_contributor_alt" {
  name        = "network-contributor-role-alt"
  scope       = azurerm_virtual_network.main_vnet.id 
  description = "Scaled down Network Contributor Role equivalent"

  permissions {
    actions = [
      "Microsoft.Network/virtualNetworks/join/action",
      "Microsoft.Network/virtualNetworks/read",
      "Microsoft.Network/virtualNetworks/write",
      "Microsoft.Network/virtualNetworks/subnets/join/action",
      "Microsoft.Network/virtualNetworks/subnets/read",
      "Microsoft.Network/virtualNetworks/subnets/write",

      "Microsoft.Network/routeTables/join/action",
      "Microsoft.Network/routeTables/read",
      "Microsoft.Network/routeTables/write",

      "Microsoft.Network/natGateways/join/action",
      "Microsoft.Network/natGateways/read",
      "Microsoft.Network/natGateways/write"
      
    ]
    data_actions = []
  }
  assignable_scopes = [
    azurerm_virtual_network.main_vnet.id 
  ]
}