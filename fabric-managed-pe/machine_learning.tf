# Machine learning workspace

module "machine_learning_workspace" {
  source = "github.com/Azure/azure-data-labs-modules/terraform/machine-learning/machine-learning-workspace"

  basename            = local.basename
  resource_group_name = local.resource_group_name
  location            = local.location

  storage_account_id      = module.storage_account_mlw.id
  key_vault_id            = module.key_vault.id
  application_insights_id = module.application_insights.id
  container_registry_id   = module.container_registry.id

  subnet_id = local.enable_private_endpoints ? module.subnet_default[0].id : null
  private_dns_zone_ids = local.enable_private_endpoints ? [
    module.private_dns_zones[0].list["privatelink.api.azureml.ms"].id,
    module.private_dns_zones[0].list["privatelink.notebooks.azure.net"].id
  ] : null

  public_network_access_enabled = true
  image_build_compute_name      = "image-builder"

  module_enabled      = true
  is_private_endpoint = local.enable_private_endpoints

  tags = local.tags
}

# Appplication insights

module "application_insights" {
  source = "github.com/Azure/azure-data-labs-modules/terraform/application-insights"

  basename            = local.basename
  resource_group_name = local.resource_group_name
  location            = local.location
  application_type    = "web"

  tags = local.tags
}

# Container registry

module "container_registry" {
  source = "github.com/Azure/azure-data-labs-modules/terraform/container-registry"

  basename            = local.safe_basename
  resource_group_name = local.resource_group_name
  location            = local.location
  sku                 = "Premium"
  admin_enabled       = true

  subnet_id            = local.enable_private_endpoints ? module.subnet_default[0].id : null
  private_dns_zone_ids = local.enable_private_endpoints ? [module.private_dns_zones[0].list["privatelink.azurecr.io"].id] : null

  is_private_endpoint = local.enable_private_endpoints

  tags = local.tags
}

# Storage Account

module "storage_account_mlw" {
  source = "github.com/Azure/azure-data-labs-modules/terraform/storage-account"

  basename            = "${local.safe_basename}mlw"
  resource_group_name = local.resource_group_name
  location            = local.location
  account_tier        = "Standard"


  subnet_id                 = local.enable_private_endpoints ? module.subnet_default[0].id : null
  private_dns_zone_ids_blob = local.enable_private_endpoints ? [module.private_dns_zones[0].list["privatelink.blob.core.windows.net"].id] : []
  private_dns_zone_ids_file = local.enable_private_endpoints ? [module.private_dns_zones[0].list["privatelink.file.core.windows.net"].id] : []

  hns_enabled             = false
  firewall_default_action = "Allow"
  firewall_ip_rules       = [data.http.ip.body]
  firewall_bypass         = ["AzureServices"]

  module_enabled      = true
  is_private_endpoint = local.enable_private_endpoints

  tags = local.tags
}