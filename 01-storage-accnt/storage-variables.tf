
variable "sa-location" {
  type        = string
  description = "Storage Account Location"
}

variable "sa-rg" {
  type        = string
  description = "Storage Account Resource Group"
}

variable "sa-name" {
  type        = string
  description = "Storage Account Name"
}

variable "container-name" {
  type        = string
  description = "Storage Account Container Name"
}

variable "noc_ip" {
 type = string
 description = "Allowed subnets for Storage Account"  
}

