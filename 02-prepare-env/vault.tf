# Create Resource Group
resource "azurerm_resource_group" "vault" {
  count    = var.create_akv ? 1 : 0
  name     = var.akv_resource_group
  location = var.key_vault_location
}

# Create AKV
resource "azurerm_key_vault" "vault" {
  count                       = var.create_akv ? 1 : 0
  name                        = local.key_vault_name
  location                    = var.key_vault_location
  resource_group_name         = var.akv_resource_group
  enabled_for_disk_encryption = false
  tenant_id                   = data.azurerm_client_config.client_config[0].tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"
  depends_on                  = [azurerm_resource_group.vault]
  enable_rbac_authorization   = true
  public_network_access_enabled = true
  network_acls {
    default_action = "Allow"
    bypass = "AzureServices"
    ip_rules = [ var.noc_ip ]
  }
}

# Section 2 - Read from Local Files
data "local_file" "myfile" {
  count    = var.read_local_file ? 1 : 0
  filename = var.secret_file_path
}

locals {
  file_contents  = var.read_local_file ? data.local_file.myfile[0].content : ""
  split_contents = var.read_local_file ? split("\n", local.file_contents) : []
  client_id      = var.read_local_file ? replace(local.split_contents[0], "client_id=", "") : ""
  client_secret  = var.read_local_file ? replace(local.split_contents[1], "client_secret=", "") : ""
  key_vault_name = "${var.cluster_name}-cluster-akv-demo"
}

# az keyvault secret show --vault-name <vault-name> --name subId | jq -r .value | sed 's/\/subscriptions\///'

