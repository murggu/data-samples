# Key vault

module "key_vault" {
  source = "github.com/Azure/azure-data-labs-modules/terraform/key-vault"

  basename                 = local.basename
  resource_group_name      = local.resource_group_name
  location                 = local.location
  sku_name                 = "premium"
  purge_protection_enabled = false

  module_enabled      = true
  is_private_endpoint = local.enable_private_endpoints

  tags = local.tags
}