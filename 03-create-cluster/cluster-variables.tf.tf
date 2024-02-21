variable "cluster_name" {
  type        = string
  description = "ARO cluster name"
}

variable "cluster_rg" {
  type        = string
  description = "ARO cluster RG Name"
}

variable "aro_version" {
  type        = string
  description = <<EOF
  ARO version
  Default "4.12.25"
  EOF
}

variable "api_server_profile" {
  type        = string
  description = <<EOF
  Api Server Profile Visibility - Public or Private
  Default "Public"
  EOF
}

variable "ingress_profile" {
  type        = string
  description = <<EOF
  Ingress Controller Profile Visibility - Public or Private
  Default "Public"
  EOF
}

variable "outbound_type" {
  type        = string
  description = <<EOF
  Outbound Type - Loadbalancer or UserDefinedRouting
  Default "Loadbalancer"
  EOF
}

variable "pull_secret_path" {
  type        = string
  description = <<EOF
  Pull Secret for the ARO cluster
  Default "false"
  EOF
}

variable "pull_secret_name" {
  type        = string
  description = <<EOF
  Pull Secret Name in AKV
  EOF
}

locals {
  akv_display_name = "${var.cluster_name}-cluster-akv-demo"
}

variable "akv_resource_group" {
  type        = string
  description = <<EOF
  AKV resource group
  EOF
}

variable "client_id_read" {
  type        = string
  description = <<EOF
  Client ID read from AKV
  EOF
}

variable "client_secret_read" {
  type        = string
  description = <<EOF
  Client Secret read from AKV
  EOF
}

variable "pull_secret_read" {
  type        = string
  description = <<EOF
  Pull Secret read from AKV
  EOF
}

variable "tenant_id_read" {
  type        = string
  description = <<EOF
  Tenant ID read from AKV
  EOF
}

variable "sub_id_read" {
  type        = string
  description = <<EOF
  Subscription ID read from AKV
  EOF
}

variable "master_vm_size" {
  type        = string
  description = <<EOF
  Instance Type of Master VM
  EOF
}

variable "encryption_at_host" {
  type        = bool
  description = <<EOF
  Host encryption for master nodes
  EOF
}

variable "master_disk_encryption_id" {
  type        = string
  description = <<EOF
  Master disk encryption ID
  EOF
}

variable "worker_vm_size" {
  type        = string
  description = <<EOF
  Instance Type of Master VM
  EOF
}

variable "worker_size_gb" {
  type        = number
  description = <<EOF
  Worker Node disk size
  EOF
}

variable "worker_node_count" {
  type        = number
  description = <<EOF
  Worker Node count
  EOF
}

variable "worker_disk_encryption_id" {
  type        = string
  description = <<EOF
  Master disk encryption ID
  EOF
}

variable "pod_cidr" {
  type        = string
  description = <<EOF
  *** Pod CIDR Name Placeholder ***
  Cluster Pod CIDR
  EOF
}

variable "service_cidr" {
  type        = string
  description = <<EOF
  *** Service CIDR Name Placeholder ***
  ARO Service CIDR
  EOF
}

variable "console_url_read" {
  type        = string
  description = <<EOF
  Console URL read from AKV
  EOF
}

variable "api_url_read" {
  type        = string
  description = <<EOF
  API URL read from AKV
  EOF
}

variable "login_username_read" {
  type        = string
  description = <<EOF
  Console URL read from AKV
  EOF
}

variable "login_password_read" {
  type        = string
  description = <<EOF
  Console URL read from AKV
  EOF
}

variable "secret_file_path" {
  type = string
  description = "secret file path"
}

locals {
  vnet_name                 = "${var.resource_group_name}-vnet"
  control_plane_subnet_name = "${var.resource_group_name}-cp-subnet"
  worker_nodes_subnet_name  = "${var.resource_group_name}-machine-subnet"
  vnet_resource_group       = "${var.resource_group_name}-vnet-rg"
}
