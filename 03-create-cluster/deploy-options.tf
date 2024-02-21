
## CLuster Egress IP
variable "restrict_egress" {
  type        = bool
  description = "Should Providers be installed?"
}

## AKV Read
variable "read_from_akv" {
  type        = bool
  description = <<EOF
  Read from AKV
  EOF
}
variable "read_from_file" {
  type        = bool
  description = <<EOF
  Read from AKV
  EOF
}

