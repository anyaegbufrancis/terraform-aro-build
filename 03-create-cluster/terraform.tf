terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      # version = "~>3.75.0"
      version = "3.89.0"
    }

    # azureopenshift = {
    #   source  = "rh-mobb/azureopenshift"
    #   version = "0.2.0-pre"
    # }

    random = {
      source  = "hashicorp/random"
      # version = "3.5.1"
    }
  }
  backend "azurerm" {
    # subscription_id = var.subscription_id
    resource_group_name  = "sa-rg"
    storage_account_name = "storageaccountname"
    container_name       = "containername"
    key                  = "demo.cluster.terraform.tfstate"
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


provider "random" {
}
