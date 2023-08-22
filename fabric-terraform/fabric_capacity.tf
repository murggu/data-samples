# Fabric Capacity

module "fabric_capacity" {
  source            = "github.com/Azure/azure-data-labs-modules/terraform/fabric/fabric-capacity"

  basename          = "${var.prefix}${var.postfix}"
  resource_group_id = module.resource_group.id
  location          = var.location

  sku               = var.sku
  admin_email       = var.admin_email
}