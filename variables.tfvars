## Common Variables ##
env                 = "demo"
support_email       = "myemail@redhat.com"
support_name        = "myname"
resource_group_name = "rg-name"

## Network Details ##
vnet_location                  = "eastus"
aro_virtual_network_cidr_block = "10.0.0.0/22"
aro_control_subnet_cidr_block  = "10.0.0.0/23"
aro_worker_subnet_cidr_block   = "10.0.2.0/23"
aro_firewall_subnet_cidr_block = "10.0.4.0/24"
pod_cidr                       = "10.0.64.0/18"
service_cidr                   = "172.32.0.0/16"

## Key Vault  Details ##
sa-location         = "eastus"
sa-rg               = "sa-rg"
key_vault_location  = "eastus"
akv_resource_group  = "akv-rg-aro"
sa-name             = "storageaccountname"
container-name      = "containername"
environment         = "Public"   ## Options - Public|usgovernment
credential_source   = "from_akv" ## Options - 'from_file'|'create_new'|'create_new'
console_url_read    = "consoleUrl"
api_url_read        = "apiUrl"
pull_secret_name    = "pullSecret"
client_id_read      = "clientId"
client_secret_read  = "clientSecret"
pull_secret_read    = "pullSecret"
tenant_id_read      = "tenantId"
sub_id_read         = "subId"

## Cluster Details ##
cluster_location          = "eastus"
cluster_name              = "dd-aro"
cluster_rg                = "aro-deploy-rg"
aro_version               = "4.13.23"
api_server_profile        = "Public"
ingress_profile           = "Public"
outbound_type             = "Loadbalancer" ## Loadbalancer|UserDefinedRouting
pull_secret_path          = "../04-secrets/pull_secret.json"
secret_file_path          = "../04-secrets/secret-data"
master_vm_size            = "Standard_D8s_v3"
encryption_at_host        = false
master_disk_encryption_id = ""
worker_vm_size            = "Standard_D8s_v3" ## "Standard_D4s_v3" #
worker_size_gb            = 128
worker_node_count         = 3
worker_disk_encryption_id = ""

## Jump Servers
aro_jumphost_name              = "arp_jumphost"
aro_jumphost_subnet_name       = "arp_jumphost_subnet"
aro_jumphost_pip_name          = "arp_jumphost_pip"
aro_jumphost_nic_name          = "arp_jumphost_nic"
aro_jumphost_subnet_cidr_block = "10.0.6.0/23"

## Deployment Options
create_jumphost          = false
create_acr               = false
install_providers        = false
restrict_egress          = false
read_from_akv            = true
read_from_file           = false
create_akv               = true
create_sp                = false
sp_to_grant_access_to_sp = false
read_local_file          = true ## Options - 'from_file'|'create_new'|'create_new'

## Common Vairables
fw_rg = "aro-fw-main"
tags = {
  environment = "dd-demo"
  owner       = "myemail@redhat.com"
  usecase     = "ngc-demo"
}
location = "eastus"

## ACR Variables
aro_private_endpoint_cidr_block        = "10.0.6.0/23"
acr_private_endpoint_subnet_name       = "acr-private-endpoint-subnet"
acr_private_dns_zone_virtual_link_name = "acr-dns-link"
acr_dns_endpoint_name                  = "privatelink.azurecr.io"
acr_private_endpoint_name              = "acr-pe"







