# Restrict Egress Traffic in a Private ARO Cluster
# For enable restrict_egress_traffic define restrict_egress_traffic = "true" in the tfvars / vars

# The Azure FW will be into the ARO subnet following the architecture
# defined in the official docs https://learn.microsoft.com/en-us/azure/openshift/howto-restrict-egress#create-an-azure-firewall

resource "azurerm_public_ip" "firewall_ip" {
  count               = var.restrict_egress ? 1 : 0
  name                = local.firewall_public_ip
  location            = var.location
  resource_group_name = var.fw_rg
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

data "azurerm_subnet" "firewall_subnet" {
  count                = var.restrict_egress ? 1 : 0
  name                 = "${var.fw_rg}-subnet"
  virtual_network_name = "${var.fw_rg}-vnet"
  resource_group_name  = var.fw_rg
}

resource "azurerm_firewall" "firewall" {
  count               = var.restrict_egress ? 1 : 0
  name                = local.firewall_name
  location            = var.location
  resource_group_name = var.fw_rg
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ip_configuration {
    name                 = local.firewall_ip_config
    subnet_id            = data.azurerm_subnet.firewall_subnet.0.id
    public_ip_address_id = azurerm_public_ip.firewall_ip.0.id
  }

}

resource "azurerm_route_table" "firewall_rt" {
  count               = var.restrict_egress ? 1 : 0
  name                = local.firewall_route_table
  location            = var.location
  resource_group_name = var.fw_rg

  # ARO User Define Routing Route
  route {
    name                   = local.firewall_route_name
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.firewall.0.ip_configuration.0.private_ip_address
  }

  tags = var.tags

}

# TODO: Restrict the FW Network Rules
resource "azurerm_firewall_network_rule_collection" "firewall_network_rules" {
  count               = var.restrict_egress ? 1 : 0
  name                = local.firewall_https_rule_1_name
  azure_firewall_name = azurerm_firewall.firewall.0.name
  resource_group_name = var.fw_rg
  priority            = 100
  action              = "Allow"

  rule {
    name                  = local.firewall_https_rule_1
    source_addresses      = local.firewall_https_rule_1_source
    destination_addresses = local.firewall_https_rule_1_destination
    protocols             = local.firewall_https_rule_1_dest_ports
    destination_ports     = local.firewall_https_rule_1_protocol
  }
}

resource "azurerm_firewall_application_rule_collection" "firewall_app_rules_aro" {
  count               = var.restrict_egress ? 1 : 0
  name                = local.firewall_https_rule_2
  azure_firewall_name = azurerm_firewall.firewall.0.name
  resource_group_name = var.fw_rg
  priority            = 101
  action              = "Allow"

  rule {
    name             = local.firewall_https_rule_2_name
    source_addresses = local.firewall_https_rule_2_source
    target_fqdns     = local.firewall_https_rule_2_target_fqdn
    protocol {
      port = "443"
      type = "Https"
    }
    protocol {
      port = "80"
      type = "Http"
    }
  }

  rule {
    name             = local.firewall_https_rule_3
    source_addresses = local.firewall_https_rule_3_source
    target_fqdns     = local.firewall_https_rule_3_target_fqdn
    protocol {
      port = "443"
      type = "Https"
    }
    protocol {
      port = "80"
      type = "Http"
    }
  }

}

resource "azurerm_firewall_application_rule_collection" "firewall_app_rules_docker" {
  count               = var.restrict_egress ? 1 : 0
  name                = local.firewall_https_rule_4_name
  azure_firewall_name = azurerm_firewall.firewall.0.name
  resource_group_name = var.fw_rg
  priority            = 200
  action              = "Allow"

  rule {
    name             = local.firewall_https_rule_4
    source_addresses = local.firewall_https_rule_4_source
    target_fqdns     = local.firewall_https_rule_4_target_fqdn
    protocol {
      port = "443"
      type = "Https"
    }
    protocol {
      port = "80"
      type = "Http"
    }
  }
}

resource "azurerm_subnet_route_table_association" "firewall_rt_aro_cp_subnet_association" {
  count          = var.restrict_egress ? 1 : 0
  subnet_id      = data.azurerm_subnet.master_subnet.id
  route_table_id = azurerm_route_table.firewall_rt.0.id
}

resource "azurerm_subnet_route_table_association" "firewall_rt_aro_machine_subnet_association" {
  count          = var.restrict_egress ? 1 : 0
  subnet_id      = data.azurerm_subnet.worker_subnet.id
  route_table_id = azurerm_route_table.firewall_rt.0.id
}
