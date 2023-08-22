terraform {
  # backend "azurerm" {}
  required_providers {
    azurerm = {
      version = "= 3.70.0"
    }
  }
}

provider "azurerm" {
  features {}
}