terraform {
  backend "azurerm" {
    # resource_group_name should be passed with ini `-backend-config` during init
    storage_account_name = "tfstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

# Needs env vars:
# ARM_SUBSCRIPTION_ID, ARM_CLIENT_ID, ARM_CLIENT_SECRET and ARM_TENANT_ID
provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "base" {
  name = lower("${var.tags.app}-${var.tags.client}-${var.tags.environment}")
}
