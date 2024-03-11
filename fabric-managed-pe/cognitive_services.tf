# Cognitive services account

module "cognitive_account" {
  source = "github.com/Azure/azure-data-labs-modules/terraform/cognitive-services/cognitive-account"

  basename            = local.safe_basename
  resource_group_name = local.resource_group_name
  location            = local.location

  kind                 = "AnomalyDetector"
  subnet_id            = local.enable_private_endpoints ? module.subnet_default[0].id : null
  private_dns_zone_ids = local.enable_private_endpoints ? [module.private_dns_zones[0].list["privatelink.cognitiveservices.azure.com"].id] : []

  module_enabled      = true
  is_private_endpoint = local.enable_private_endpoints

  tags = local.tags
}