# Fabric private link

resource "azapi_resource" "pbi_privatelink" {
  type      = "Microsoft.PowerBI/privateLinkServicesForPowerBI@2020-06-01"
  name      = "plfabric"
  location  = "global"
  parent_id = module.resource_group.id

  tags = local.tags

  body = jsonencode({
    properties = {
      privateEndpointConnections = [
      ]
      tenantId = data.azurerm_client_config.current.tenant_id
    }
  })
}