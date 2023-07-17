# Databricks workspace

module "databricks_workspace" {
  source = "github.com/Azure/azure-data-labs-modules/terraform/databricks/databricks-workspace"

  basename            = local.basename
  resource_group_name = local.resource_group_name
  location            = local.location

  public_network_access_enabled = true

  module_enabled      = true
  is_private_endpoint = local.enable_private_endpoints

  tags = local.tags
}