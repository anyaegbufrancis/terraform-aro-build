

variable "aro_jumphost_subnet_cidr_block" {
  type        = string
  description = "cidr range for bastion / jumphost"
}

variable "aro_jumphost_name" {
  type        = string
  description = "Name of jumphost subnet"
}

variable "aro_jumphost_subnet_name" {
  type        = string
  description = "Jump host Name for connecting to private ARO cluster"
}

variable "aro_jumphost_pip_name" {
  type        = string
  description = "Jump host Public IP Address"
}

variable "aro_jumphost_nic_name" {
  type        = string
  description = "Jump host Public IP Address"
}