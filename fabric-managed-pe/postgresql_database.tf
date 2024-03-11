# Psql server

resource "azurerm_postgresql_server" "psql_server" {
  name                = "psql-server-${local.basename}"
  resource_group_name = local.resource_group_name
  location            = local.location

  administrator_login          = "sqladminuser"
  administrator_login_password = "ThisIsNotVerySecure!"

  sku_name   = "GP_Gen5_2"
  version    = "11"
  storage_mb = 5120

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = true

  public_network_access_enabled    = false
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"

  tags = local.tags
}

# Psql database

resource "azurerm_postgresql_database" "psql_db" {
  name                = "psql-${local.basename}"
  resource_group_name = local.resource_group_name
  server_name         = azurerm_postgresql_server.psql_server.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

# Private endpoint

module "psql_pe" {
  source = "github.com/Azure/azure-data-labs-modules/terraform//private-endpoint"

  basename            = azurerm_postgresql_server.psql_server.name
  resource_group_name = local.resource_group_name
  location            = local.location

  subnet_id                      = local.enable_private_endpoints ? module.subnet_default[0].id : null
  private_connection_resource_id = azurerm_postgresql_server.psql_server.id
  subresource_names              = ["postgresqlServer"]
  is_manual_connection           = false
  private_dns_zone_ids           = local.enable_private_endpoints ? [module.private_dns_zones[0].list["privatelink.postgres.database.azure.com"].id] : []

  module_enabled = true

  tags = local.tags
}