variable "resource_group_name" {
  description = "ARO main Resource Group name"
}

variable "environment" {
  description = "Deployment Environment"
}

variable "tags" {
  type = map(string)
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "credential_source" {
  type        = string
  description = <<EOF
  Source of the service principal for cluster creation
  'create_new' or 'from_file', or 'from_akv'
  EOF
}

variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID (needed with the new Auth method)"
}
