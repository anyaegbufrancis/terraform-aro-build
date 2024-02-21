data "azuread_application_published_app_ids" "well_known" {
  count = var.create_akv ? 1 : 0
}

data "azuread_client_config" "current" {}

data "azurerm_subscription" "sub" {
  count = var.create_akv ? 1 : 0
}

data "azurerm_client_config" "client_config" {
  count = var.create_akv ? 1 : 0
}

resource "azuread_service_principal" "msgraph" {
  count        = (var.create_akv && var.create_sp) ? 1 : 0
  client_id    = data.azuread_application_published_app_ids.well_known[0].result.MicrosoftGraph
  use_existing = true
}

# ## Create App Registration for Secret Read Operation 

resource "azuread_application" "myapp_read" {
  count        = var.create_akv ? 1 : 0
  display_name = "vault-secret-read-access-reg"
  owners       = [data.azuread_client_config.current.object_id]
}

# Create Service Principal
resource "azuread_service_principal" "myapp_read" {
  count     = var.create_akv ? 1 : 0
  client_id = azuread_application.myapp_read[0].client_id
  owners    = [data.azuread_client_config.current.object_id]
}

## Create App Registration password
resource "azuread_application_password" "myapp_read" {
  count          = var.create_akv ? 1 : 0
  display_name   = "vault-secret-read-access-reg"
  application_id = azuread_application.myapp_read[0].id ## Changed
}

resource "azurerm_role_assignment" "akv_sp_read" {
  count                = var.create_akv ? 1 : 0
  scope                = azurerm_key_vault.vault[0].id
  role_definition_name = "read-from-akv"
  principal_id         = azuread_service_principal.myapp_read[0].object_id
  depends_on           = [ azurerm_role_definition.myapp_read ]
}

resource "azurerm_role_definition" "myapp_read" {
  name        = "read-from-akv"
  scope       = azurerm_key_vault.vault[0].id
  description = "Custom Role for Read to AKV"

  permissions {
    data_actions = ["Microsoft.KeyVault/vaults/secrets/getSecret/action"]
  }
  assignable_scopes = [
    azurerm_key_vault.vault[0].id
  ]
}

## Create SP for Secret Push to Store from K8S

resource "azuread_application" "myapp_push" {
  count        = var.create_akv ? 1 : 0
  display_name = "vault-secret-push-access-reg"
  owners       = [data.azuread_client_config.current.object_id]
}

# Create Service Principal
resource "azuread_service_principal" "myapp_push" {
  count     = var.create_akv ? 1 : 0
  client_id = azuread_application.myapp_push[0].client_id
  owners    = [data.azuread_client_config.current.object_id]
}

## Create App Registration password
resource "azuread_application_password" "myapp_push" {
  count          = var.create_akv ? 1 : 0
  display_name   = "vault-secret-push-access-reg"
  application_id = azuread_application.myapp_push[0].id
}

resource "azurerm_role_assignment" "akv_sp_push" {
  count                = var.create_akv ? 1 : 0
  scope                = azurerm_key_vault.vault[0].id
  role_definition_name = "write-to-akv"
  principal_id         = azuread_service_principal.myapp_push[0].object_id
  depends_on           = [ azurerm_role_definition.myapp_push ]
}

resource "azurerm_role_definition" "myapp_push" {
  name        = "write-to-akv"
  scope       = azurerm_key_vault.vault[0].id
  description = "Custom Role for Write to AKV"

  permissions {
    actions     = []
    not_actions = []
    data_actions = [
      "Microsoft.KeyVault/vaults/secrets/setSecret/action",
      "Microsoft.KeyVault/vaults/secrets/update/action",
      "Microsoft.KeyVault/vaults/secrets/getSecret/action"
    ]
    not_data_actions = []
  }
  assignable_scopes = [
    azurerm_key_vault.vault[0].id
  ]
}

resource "azurerm_role_definition" "vault_def_permission" {
  name        = "admin-owner-akv-role"
  scope       = azurerm_key_vault.vault[0].id
  description = "Custom Role for Admin AKV Owner"

  permissions {
    actions = []
    data_actions = [
      "Microsoft.KeyVault/vaults/secrets/*"
    ]
  }
  assignable_scopes = [
    azurerm_key_vault.vault[0].id
  ]
}

resource "azurerm_role_assignment" "vault_def_permission" {
  count                = var.create_akv ? 1 : 0
  scope                = azurerm_key_vault.vault[0].id
  role_definition_name = azurerm_role_definition.vault_def_permission.name
  principal_id         = data.azurerm_client_config.client_config[0].object_id
  depends_on           = [azurerm_role_definition.vault_def_permission, azurerm_key_vault.vault[0]]
}

