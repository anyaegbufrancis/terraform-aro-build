resource "azurerm_key_vault_secret" "client_id" {
  name         = var.client_id_read
  value        = local.client_id
  key_vault_id = azurerm_key_vault.vault[0].id
  depends_on = [ azurerm_role_assignment.vault_def_permission[0] ]
}
resource "azurerm_key_vault_secret" "client_secret" {
  name         = var.client_secret_read
  value        = local.client_secret
  key_vault_id = azurerm_key_vault.vault[0].id
  depends_on = [ azurerm_role_assignment.vault_def_permission[0] ]
}
resource "azurerm_key_vault_secret" "tenant_id_read" {
  name         = var.tenant_id_read
  value        = data.azurerm_client_config.client_config[0].tenant_id
  key_vault_id = azurerm_key_vault.vault[0].id
  depends_on = [ azurerm_role_assignment.vault_def_permission[0] ]
}
resource "azurerm_key_vault_secret" "sub_id_read" {
  name         = var.sub_id_read
  value        = data.azurerm_subscription.sub[0].id
  key_vault_id = azurerm_key_vault.vault[0].id
  depends_on = [ azurerm_role_assignment.vault_def_permission[0] ]
}
resource "azurerm_key_vault_secret" "pull_secret_name" {
  name         = var.pull_secret_name
  value        = file(var.pull_secret_path)
  key_vault_id = azurerm_key_vault.vault[0].id
  depends_on = [ azurerm_role_assignment.vault_def_permission[0] ]
}
resource "azurerm_key_vault_secret" "console_url_read" {
  name         = var.console_url_read
  value        = "https://api.${var.cluster_name}.${var.cluster_location}.aroapp.io:6443"
  key_vault_id = azurerm_key_vault.vault[0].id
  depends_on = [ azurerm_role_assignment.vault_def_permission[0] ]
}
resource "azurerm_key_vault_secret" "api_url_read" {
  name         = var.api_url_read
  value        = "https://console-openshift-console.apps.${var.cluster_name}.${var.cluster_location}.aroapp.io"
  key_vault_id = azurerm_key_vault.vault[0].id
  depends_on = [ azurerm_role_assignment.vault_def_permission[0] ]
}
# resource "azurerm_key_vault_secret" "login_username_read" {
#   name         = var.login_username_read
#   value        = var.login_username
#   key_vault_id = azurerm_key_vault.vault[0].id
#   depends_on = [ azurerm_role_assignment.vault_def_permission[0] ]
# }
# resource "azurerm_key_vault_secret" "login_password_read" {
#   name         = var.login_password_read
#   value        = var.login_password
#   key_vault_id = azurerm_key_vault.vault[0].id
#   depends_on = [ azurerm_role_assignment.vault_def_permission[0] ]
# }
resource "azurerm_key_vault_secret" "psqluname" {
  name         = var.psqluname
  value        = random_string.psqluname.result
  key_vault_id = azurerm_key_vault.vault[0].id
  depends_on = [ azurerm_role_assignment.vault_def_permission[0] ]
}
resource "azurerm_key_vault_secret" "psqlpassword" {
  name         = var.psqlpassword
  value        = random_password.psqlpassword.result
  key_vault_id = azurerm_key_vault.vault[0].id
  depends_on = [ azurerm_role_assignment.vault_def_permission[0] ]
}
resource "azurerm_key_vault_secret" "vault-secret-read-access-reg-id" {
  name         = "vault-secret-read-access-reg-id"
  value        = azuread_application.myapp_read[0].client_id
  key_vault_id = azurerm_key_vault.vault[0].id
  depends_on = [ azurerm_role_assignment.vault_def_permission[0] ]
}
resource "azurerm_key_vault_secret" "vault-secret-read-access-reg-pw" {
  name         = "vault-secret-read-access-reg-pw"
  value        = azuread_application_password.myapp_read[0].value
  key_vault_id = azurerm_key_vault.vault[0].id
  depends_on = [ azurerm_role_assignment.vault_def_permission[0] ]
}
resource "azurerm_key_vault_secret" "vault-secret-push-access-reg-id" {
  name         = "vault-secret-push-access-reg-id"
  value        = azuread_application.myapp_push[0].client_id
  key_vault_id = azurerm_key_vault.vault[0].id
  depends_on = [ azurerm_role_assignment.vault_def_permission[0] ]
}
resource "azurerm_key_vault_secret" "vault-secret-push-access-reg-pw" {
  name         = "vault-secret-push-access-reg-pw"
  value        = azuread_application_password.myapp_push[0].value
  key_vault_id = azurerm_key_vault.vault[0].id
  depends_on = [ azurerm_role_assignment.vault_def_permission[0] ]
}


