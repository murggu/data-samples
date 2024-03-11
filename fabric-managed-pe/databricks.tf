# Databricks workspace

resource "azurerm_databricks_workspace" "example" {
  name                = "adb-${local.basename}"
  resource_group_name = local.resource_group_name
  location            = local.location
  sku                 = "premium"

  managed_resource_group_name = "${local.resource_group_name}-adb"

  public_network_access_enabled         = false
  network_security_group_rules_required = "NoAzureDatabricksRules"

  custom_parameters {
    no_public_ip        = true
    public_subnet_name  = module.dbx_snet_public.name
    private_subnet_name = module.dbx_snet_private.name
    virtual_network_id  = module.virtual_network[0].id

    public_subnet_network_security_group_association_id  = module.dbx_snet_nsg_association_public.id
    private_subnet_network_security_group_association_id = module.dbx_snet_nsg_association_private.id
  }

  tags = local.tags
}

# Network

module "dbx_snet_public" {
  source = "github.com/Azure/azure-data-labs-modules/terraform/subnet"

  resource_group_name = local.resource_group_name
  name                = "snet-${local.prefix}-${local.postfix}-dbx-public"
  vnet_name           = module.virtual_network[0].name
  address_prefixes    = ["10.0.4.0/24"]
  subnet_delegation = {
    databricks-del-pub = [
      {
        name = "Microsoft.Databricks/workspaces"
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action",
          "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
          "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
        ]
      }
    ]
  }
}

module "dbx_snet_private" {
  source = "github.com/Azure/azure-data-labs-modules/terraform/subnet"

  resource_group_name = local.resource_group_name
  name                = "snet-${local.prefix}-${local.postfix}-dbx-private"
  vnet_name           = module.virtual_network[0].name
  address_prefixes    = ["10.0.5.0/24"]
  subnet_delegation = {
    databricks-del-pri = [
      {
        name = "Microsoft.Databricks/workspaces"
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action",
          "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
          "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
        ]
      }
    ]
  }
}

module "dbx_nsg" {
  source              = "github.com/Azure/azure-data-labs-modules/terraform/network-security-group"
  basename            = local.basename
  resource_group_name = local.resource_group_name
  location            = local.location
}

module "dbx_snet_nsg_association_public" {
  source                    = "github.com/Azure/azure-data-labs-modules/terraform/subnet-network-security-group-association"
  subnet_id                 = module.dbx_snet_public.id
  network_security_group_id = module.dbx_nsg.id
}

module "dbx_snet_nsg_association_private" {
  source                    = "github.com/Azure/azure-data-labs-modules/terraform/subnet-network-security-group-association"
  subnet_id                 = module.dbx_snet_private.id
  network_security_group_id = module.dbx_nsg.id
}

# Private endpoint

resource "azurerm_private_endpoint" "databricks" {
  name                = "pe-${local.basename}"
  resource_group_name = local.resource_group_name
  location            = local.location
  subnet_id           = module.subnet_default[0].id

  private_service_connection {
    name                           = "psc-${local.basename}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_databricks_workspace.example.id
    subresource_names              = ["databricks_ui_api"]
  }
}

resource "azurerm_private_dns_zone" "example" {
  depends_on = [azurerm_private_endpoint.databricks]

  name                = "privatelink.azuredatabricks.net"
  resource_group_name = local.resource_group_name
}

resource "azurerm_private_dns_cname_record" "example" {
  name                = azurerm_databricks_workspace.example.workspace_url
  zone_name           = azurerm_private_dns_zone.example.name
  resource_group_name = local.resource_group_name
  ttl                 = 300
  record              = "northeurope-c2.azuredatabricks.net"
}