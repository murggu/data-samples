# CosmosDB account

module "cosmosdb_account" {
  source = "github.com/Azure/azure-data-labs-modules/terraform/cosmosdb/cosmosdb-account"

  basename            = local.safe_basename
  resource_group_name = local.resource_group_name
  location            = local.location

  kind                = "GlobalDocumentDB"
  enable_capabilities = ["DisableRateLimitingResponses"]

  module_enabled = true

  tags = local.tags
}

# CosmosDB NoSQL

module "cosmosdb_sql_database" {
  source = "github.com/Azure/azure-data-labs-modules/terraform/cosmosdb/cosmosdb-sql-database"

  basename            = local.safe_basename
  resource_group_name = local.resource_group_name
  location            = local.location

  subnet_id            = local.enable_private_endpoints ? module.subnet_default[0].id : null
  private_dns_zone_ids = local.enable_private_endpoints ? [module.private_dns_zones[0].list["privatelink.documents.azure.com"].id] : []

  cosmosdb_account_id   = module.cosmosdb_account.id
  cosmosdb_account_name = module.cosmosdb_account.name

  module_enabled      = true
  is_private_endpoint = local.enable_private_endpoints

  tags = local.tags
}