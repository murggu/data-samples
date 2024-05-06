locals {
  tags = {
    Toolkit  = "Terraform"
    Template = "fab-managed-private-link"
  }

  dns_zones = [
    "privatelink.analysis.windows.net",
    "privatelink.pbidedicated.windows.net",
    "privatelink.prod.powerquery.microsoft.com"
  ]

  safe_prefix  = replace(local.prefix, "-", "")
  safe_postfix = replace(local.postfix, "-", "")

  basename      = "${local.prefix}-${local.postfix}"
  safe_basename = "${local.safe_prefix}${local.safe_postfix}"

  # Configuration

  config = yamldecode(file("${path.module}/config-lab.yml"))

  resource_group_name = module.resource_group.name
  location            = local.config.variables.location != null ? local.config.variables.location : var.location
  prefix              = local.config.variables.prefix != null ? local.config.variables.prefix : var.prefix
  postfix             = local.config.variables.postfix != null ? local.config.variables.postfix : var.postfix

  enable_private_endpoints = local.config.variables.enable_private_endpoints != null ? local.config.variables.enable_private_endpoints : var.enable_private_endpoints
  enable_jumphost          = local.config.variables.enable_jumphost != null ? local.config.variables.enable_jumphost : var.enable_jumphost
}