
data "azurerm_key_vault" "akv_id_read" {
  count               = var.read_from_akv ? 1 : 0
  name                = local.akv_display_name
  resource_group_name = var.akv_resource_group
}

data "azurerm_key_vault_secret" "client_id_read" {
  count        = var.read_from_akv ? 1 : 0
  name         = var.client_id_read
  key_vault_id = data.azurerm_key_vault.akv_id_read[0].id
}

data "azurerm_key_vault_secret" "client_secret_read" {
  count        = var.read_from_akv ? 1 : 0
  name         = var.client_secret_read
  key_vault_id = data.azurerm_key_vault.akv_id_read[0].id
}

data "azurerm_key_vault_secret" "tenant_id_read" {
  count        = var.read_from_akv ? 1 : 0
  name         = var.tenant_id_read
  key_vault_id = data.azurerm_key_vault.akv_id_read[0].id
}

data "azurerm_key_vault_secret" "pull_secret_read" {
  count        = var.read_from_akv ? 1 : 0
  name         = var.pull_secret_read
  key_vault_id = data.azurerm_key_vault.akv_id_read[0].id
}

data "azurerm_key_vault_secret" "sub_id_read" {
  count        = var.read_from_akv ? 1 : 0
  name         = var.sub_id_read
  key_vault_id = data.azurerm_key_vault.akv_id_read[0].id
}

# data "azurerm_key_vault_secret" "login_username_read" {
#   count        = var.read_from_akv ? 1 : 0
#   name         = var.login_username_read
#   key_vault_id = data.azurerm_key_vault.akv_id_read[0].id
# }

# data "azurerm_key_vault_secret" "login_password_read" {
#   count        = var.read_from_akv ? 1 : 0
#   name         = var.login_password_read
#   key_vault_id = data.azurerm_key_vault.akv_id_read[0].id
# }

## Read Subnet IDs
data "azurerm_subnet" "master_subnet" {
  name                 = local.control_plane_subnet_name
  virtual_network_name = local.vnet_name
  resource_group_name  = local.vnet_resource_group
}

data "azurerm_subnet" "worker_subnet" {
  name                 = local.worker_nodes_subnet_name
  virtual_network_name = local.vnet_name
  resource_group_name  = local.vnet_resource_group
}

# data "azurerm_virtual_network" "vnet_read" {
#   name                = local.vnet_name
#   resource_group_name = local.vnet_resource_group
# }


# resource "azurerm_role_assignment" "rg" {
#   scope                = data.azurerm_resource_group.rg_read.id
#   role_definition_name = azurerm_role_definition.network_contributor_alt.name
#   principal_id         = data.azuread_service_principal.aro_resource_provisioner.object_id
#   depends_on = [ azurerm_role_definition.network_contributor_alt ]
# }

## Create ARO Cluster with SP Details from AKV
# resource "azureopenshift_redhatopenshift_cluster" "cluster_from_akv" {
resource "azurerm_redhat_openshift_cluster" "cluster_from_akv" {
  count                  = var.read_from_akv ? 1 : 0
  name                   = var.cluster_name
  location               = var.location
  resource_group_name    = var.resource_group_name
  tags = var.tags

  main_profile {
    subnet_id           = data.azurerm_subnet.master_subnet.id
    vm_size             = var.master_vm_size
    encryption_at_host_enabled  = var.encryption_at_host
    # disk_encryption_set_id = var.master_disk_encryption_id ## Disk encryption set resource ID
  }
  worker_profile {
    subnet_id           = data.azurerm_subnet.worker_subnet.id
    vm_size             = var.worker_vm_size
    disk_size_gb        = var.worker_size_gb
    encryption_at_host_enabled  = var.encryption_at_host
    # disk_encryption_set_id = var.worker_disk_encryption_id ## Disk encryption set resource ID
    node_count          = var.worker_node_count
  }

  service_principal {
    client_id     = data.azurerm_key_vault_secret.client_id_read[0].value
    client_secret = data.azurerm_key_vault_secret.client_secret_read[0].value
  }

  api_server_profile {
    visibility = var.api_server_profile
    # ip_address = "192.168.100.100"
    # url = "console_url"
  }

  ingress_profile {
    visibility = var.ingress_profile
    # ip_address = "192.168.100.200"
    # name = "ingress_name"
  }

  cluster_profile {
    pull_secret = data.azurerm_key_vault_secret.pull_secret_read[0].value
    version     = var.aro_version
    domain      = var.cluster_name ## Optional
    fips_enabled = false ## Options true/false
    # resource_group_id = "someval"  ### Resource Group where cluster profile is attached to
  }

  network_profile {
    outbound_type = var.outbound_type
    pod_cidr      = var.pod_cidr
    service_cidr  = var.service_cidr
  }
}

# Section - Read from Local Files
data "local_file" "myfile" {
  count    = var.read_from_file ? 1 : 0
  filename = var.secret_file_path
}

locals {
  file_contents  = var.read_from_file ? data.local_file.myfile[0].content : []
  split_contents = var.read_from_file ? split("\n", local.file_contents) : []
  client_id      = var.read_from_file ? replace(local.split_contents[0], "client_id=", "") : ""
  client_secret  = var.read_from_file ? replace(local.split_contents[1], "client_secret=", "") : ""
}

## Create ARO Cluster with Creds from localfile
resource "azurerm_redhat_openshift_cluster" "cluster_from_file" {
  count                  = !var.read_from_akv ? 1 : 0
  name                   = var.cluster_name
  location               = var.location
  resource_group_name    = var.resource_group_name
  tags                   = var.tags

  main_profile {
    subnet_id           = data.azurerm_subnet.master_subnet.id
    vm_size             = var.master_vm_size
    encryption_at_host_enabled  = var.encryption_at_host
    disk_encryption_set_id = var.master_disk_encryption_id
  }
  worker_profile {
    subnet_id           = data.azurerm_subnet.worker_subnet.id
    vm_size             = var.worker_vm_size
    disk_size_gb        = var.worker_size_gb
    encryption_at_host_enabled  = var.encryption_at_host
    disk_encryption_set_id = var.worker_disk_encryption_id
    node_count          = var.worker_node_count
  }

  service_principal {
    client_id     = local.client_id
    client_secret = local.client_secret
  }

  api_server_profile {
    visibility = var.api_server_profile
  }

  ingress_profile {
    visibility = var.ingress_profile
  }

  cluster_profile {
    pull_secret            = var.read_from_akv ? data.azurerm_key_vault_secret.pull_secret_read[0].value : file(var.pull_secret_path)
    version                = var.aro_version
    domain                 = var.cluster_name ## Optional
    fips_enabled = false       ## Options true/false
  }

  network_profile {
    outbound_type = var.outbound_type
    pod_cidr      = var.pod_cidr
    service_cidr  = var.service_cidr
  }
}