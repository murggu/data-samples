variable "location" {
  type        = string
  description = "Location of the resource group and modules"
  default     = "North Europe"
}

variable "prefix" {
  type        = string
  description = "Prefix for module names"
  default     = "test"
}

variable "postfix" {
  type        = string
  description = "Postfix for module names"
  default     = "102"
}

variable "sku" {
  type        = string
  description = "F SKU"
  default     = "F2"
}

variable "admin_email" {
  type        = string
  description = "Admin email address"
  default     = "aimurg@microsoft.com"
}