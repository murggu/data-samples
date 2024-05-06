# Private endpoint

module "fabric_pe" {
  source = "github.com/Azure/azure-data-labs-modules/terraform/private-endpoint"

  basename            = "fabric-${local.basename}"
  resource_group_name = local.resource_group_name
  location            = local.location

  subnet_id                      = local.enable_private_endpoints ? module.subnet_default[0].id : null
  private_connection_resource_id = azapi_resource.pbi_privatelink.id
  subresource_names              = ["tenant"]
  is_manual_connection           = false
  private_dns_zone_ids = local.enable_private_endpoints ? [
    module.private_dns_zones[0].list["privatelink.analysis.windows.net"].id,
    module.private_dns_zones[0].list["privatelink.pbidedicated.windows.net"].id,
    module.private_dns_zones[0].list["privatelink.prod.powerquery.microsoft.com"].id
  ] : []

  module_enabled = true

  tags = local.tags
}