
resource "azurerm_resource_group" "sa-rg" {
  name     = "sa-rg"
  location = var.sa-location
}

resource "azurerm_storage_account" "sa-account" {
  name                     = var.sa-name
  resource_group_name      = var.sa-rg
  location                 = var.sa-location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  network_rules {
    default_action = "Deny"
    bypass = [ "None" ]
    ip_rules = [ var.noc_ip ]
  }

  tags = {
    created_by = "fanyaegb@redhat.com"
    purpose    = "tf-storage-account"
  }
  depends_on = [azurerm_resource_group.sa-rg]
}

resource "azurerm_storage_container" "sa-container" {
  name                  = var.container-name
  storage_account_name  = var.sa-name
  container_access_type = "blob"
  depends_on            = [azurerm_resource_group.sa-rg, azurerm_storage_account.sa-account]
}

