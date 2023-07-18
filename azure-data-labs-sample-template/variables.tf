variable "location" {
  type        = string
  description = "Location of the resource group and modules"
  default     = "North Europe"
}

variable "prefix" {
  type        = string
  description = "Prefix for module names"
  default     = "adl"
}

variable "postfix" {
  type        = string
  description = "Postfix for module names"
  default     = "sample02"
}

# Feature flags

variable "enable_private_endpoints" {
  type        = bool
  description = "Is secure enabled?"
  default     = false
}