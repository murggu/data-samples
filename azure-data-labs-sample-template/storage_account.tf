# Storage account

module "storage_account" {
  source = "github.com/Azure/azure-data-labs-modules/terraform/storage-account"

  basename            = local.safe_basename
  resource_group_name = local.resource_group_name
  location            = local.location
  account_tier        = "Standard"

  hns_enabled             = true
  firewall_default_action = "Allow"
  firewall_ip_rules       = [data.http.ip.body]
  firewall_bypass         = ["AzureServices"]

  module_enabled      = true
  is_private_endpoint = local.enable_private_endpoints

  tags = local.tags
}
