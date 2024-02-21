
variable "create_akv" {
  type        = bool
  description = "Create a new AKV?"
}

variable "create_sp" {
  type        = bool
  description = "Create service principal that has access to akv"
}

variable "read_local_file" {
  type        = bool
  description = <<EOF
  Determines whether local credential file needs to be used
  EOF
}

variable "psqluname" {
  type        = string
  description = <<EOF
  postgresql username
  EOF
}

variable "psqlpassword" {
  type        = string
  description = <<EOF
  postgresql password
  EOF
}

resource "random_string" "random" {
  length  = 6
  special = false
}

resource "random_string" "psqluname" {
  length  = 12
  special = true
}

resource "random_password" "psqlpassword" {
  length           = 48
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

variable "key_vault_location" {
  description = "Azure Key Vault Default Region"
}

variable "akv_resource_group" {
  description = "Vault Resource Group"
}

variable "cluster_location" {
  type        = string
  description = "Cluster Default Region"
}

variable "cluster_name" {
  description = "VNET Default Region"
}

variable "pull_secret_name" {
  type        = string
  description = <<EOF
  Pull Secret Name in AKV
  EOF
}

##Key of Secrets in AKV
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

variable "login_username" {
  type        = string
  description = <<EOF
  Login Username
  EOF
}

variable "login_password" {
  type        = string
  description = <<EOF
  Login Password
  EOF
}
variable "secret_file_path" {
  type        = string
  description = "path to secret data file"
}
variable "pull_secret_path" {
  type        = string
  description = "path to secret data file"
}

variable "noc_ip" {
  type        = string
  description = "NOC Source Subnet"
}

variable "user_id" {
  type        = string
  description = "My SP ID"
}


