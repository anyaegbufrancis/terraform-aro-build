terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  backend "azurerm" {
    resource_group_name  = "sa-rg"
    storage_account_name = "arodemotfstatestacnt"
    container_name       = "arodemotfstatecontainer"
    key                  = "demo.prep.terraform.tfstate"
  }
}

provider "azurerm" {
  skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  subscription_id = var.subscription_id
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
