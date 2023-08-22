# Resource group

module "resource_group" {
  source = "github.com/Azure/azure-data-labs-modules/terraform/resource-group"

  basename = "${var.prefix}-${var.postfix}"
  location = var.location
}