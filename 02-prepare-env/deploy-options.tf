
## Jumphost create
variable "create_jumphost" {
  description = "Should Jumphost be created for Private ARO cluster? Default false"
}

## ACR create
variable "create_acr" {
  description = "Should ACR be created for Private ARO cluster? Default false"
}

## Install Providers?
variable "install_providers" {
  description = "Should Providers be installed?"
}

## Create Egress Restriction Network?
variable "restrict_egress" {
  description = "Should Providers be installed?"
}

