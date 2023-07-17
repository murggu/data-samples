locals {
  tags = {
    Owner       = "Azure Data Labs"
    Project     = "Azure Data Labs"
    Environment = "dev"
    Toolkit     = "Terraform"
    Template    = "sample-template"
    Name        = "${var.prefix}"
  }

  dns_zones = [
  ]

  safe_prefix  = replace(local.prefix, "-", "")
  safe_postfix = replace(local.postfix, "-", "")

  basename      = "${local.prefix}-${local.postfix}"
  safe_basename = "${local.safe_prefix}${local.safe_postfix}"

  # Configuration
  resource_group_name = module.resource_group.name
  location            = var.location
  prefix              = var.prefix
  postfix             = var.postfix

  enable_private_endpoints = var.enable_private_endpoints
  enable_ade_deployment    = false
}