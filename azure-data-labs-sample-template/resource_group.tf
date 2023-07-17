# Resource group

module "resource_group" {
  source = "github.com/Azure/azure-data-labs-modules/terraform/resource-group"

  basename = local.basename
  location = local.location

  module_enabled = true
  tags           = local.tags
}