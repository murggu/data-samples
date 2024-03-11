# MySQL server

resource "azurerm_mysql_server" "mysql_server" {
  name                = "mysql-server-${local.basename}"
  resource_group_name = local.resource_group_name
  location            = local.location

  administrator_login          = "sqladminuser"
  administrator_login_password = "ThisIsNotVerySecure!"

  sku_name                          = "GP_Gen5_2"
  storage_mb                        = 5120
  version                           = "8.0"
  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = false
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"

  tags = local.tags
}

# MySql database

resource "azurerm_mysql_database" "mysql_databases" {
  name                = "mysql-${local.basename}"
  resource_group_name = local.resource_group_name
  server_name         = azurerm_mysql_server.mysql_server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

# Private endpoint

module "mysql_pe" {
  source = "github.com/Azure/azure-data-labs-modules/terraform//private-endpoint"

  basename            = azurerm_mysql_server.mysql_server.name
  resource_group_name = local.resource_group_name
  location            = local.location

  subnet_id                      = local.enable_private_endpoints ? module.subnet_default[0].id : null
  private_connection_resource_id = azurerm_mysql_server.mysql_server.id
  subresource_names              = ["mysqlServer"]
  is_manual_connection           = false
  private_dns_zone_ids           = local.enable_private_endpoints ? [module.private_dns_zones[0].list["privatelink.mysql.database.azure.com"].id] : []

  module_enabled = true

  tags = local.tags
}