variable "location" {
  type        = string
  description = "Location of the resource group and modules"
  default     = "North Europe"
}

variable "prefix" {
  type        = string
  description = "Prefix for module names"
  default     = "fab-pe"
}

variable "postfix" {
  type        = string
  description = "Postfix for module names"
  default     = "101"
}

variable "jumphost_username" {
  type        = string
  description = "VM username"
  default     = "azureuser"
}

variable "jumphost_password" {
  type        = string
  description = "VM password"
  default     = "ThisIsNotVerySecure!"
}

variable "tenant_id" {
  description = "Tenant id"
  type        = string
  default     = ""
}

# Feature flags

variable "enable_private_endpoints" {
  type        = bool
  description = "Is secure enabled?"
  default     = true
}

variable "enable_jumphost" {
  type        = bool
  description = "Is jumphost required?"
  default     = false
}