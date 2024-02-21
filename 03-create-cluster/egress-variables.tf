variable "fw_rg" {
  description = "FW Resource Group name"
  default     = "aro-fw-main"
}

locals {
  firewall_name = "${var.resource_group_name}-firewall"
}

locals {
  firewall_subnet_name              = "${local.firewall_name}-subnet"
  firewall_public_ip                = "${local.firewall_name}-public-ip"
  firewall_ip_config                = "${local.firewall_name}-ip-config"
  firewall_route_table              = "${local.firewall_name}-route-table"
  firewall_route_name               = "${local.firewall_name}-udr"
  firewall_https_rule_1_name        = "${local.firewall_name}-allow-https"
  firewall_https_rule_1             = "${local.firewall_name}-allow-all"
  firewall_https_rule_1_source      = ["*", ]
  firewall_https_rule_1_destination = ["*"]
  firewall_https_rule_1_protocol    = ["Any"]
  firewall_https_rule_1_dest_ports  = ["1-65535", ]
  firewall_https_rule_2             = "${local.firewall_name}-ARO"
  firewall_https_rule_2_name        = "${local.firewall_name}-aro-required"
  firewall_https_rule_2_source      = ["*", ]
  firewall_https_rule_2_target_fqdn = [
    "cert-api.access.redhat.com",
    "api.openshift.com",
    "api.access.redhat.com",
    "infogw.api.openshift.com",
    "registry.redhat.io",
    "access.redhat.com",
    "*.quay.io",
    "sso.redhat.com",
    "*.openshiftapps.com",
    "mirror.openshift.com",
    "registry.access.redhat.com",
    "*.redhat.com",
    "*.openshift.com",
    "*.microsoft.com"
  ]
  firewall_https_rule_3        = "${local.firewall_name}-azurespecific"
  firewall_https_rule_3_source = ["*", ]
  firewall_https_rule_3_target_fqdn = [
    "*.azurecr.io",
    "*.azure.com",
    "login.microsoftonline.com",
    "*.windows.net",
    "dc.services.visualstudio.com",
    "*.ods.opinsights.azure.com",
    "*.oms.opinsights.azure.com",
    "*.monitoring.azure.com",
    "*.azure.cn"
  ]
  firewall_https_rule_4_name   = "${local.firewall_name}-Docker"
  firewall_https_rule_4        = "${local.firewall_name}-docker"
  firewall_https_rule_4_source = ["*", ]
  firewall_https_rule_4_target_fqdn = [
    "*cloudflare.docker.com",
    "*registry-1.docker.io",
    "apt.dockerproject.org",
    "auth.docker.io"
  ]
}