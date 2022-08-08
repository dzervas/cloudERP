# Needs env vars:
# ARM_SUBSCRIPTION_ID, ARM_CLIENT_ID, ARM_CLIENT_SECRET and ARM_TENANT_ID
# terraform {
#   backend "azurerm" {
#     resource_group_name  = "tfstate"
#     storage_account_name = var.tfstate_storage_account_name
#     container_name       = "tfstate"
#     key                  = "terraform.tfstate"
#   }
# }

data "terraform_remote_state" "tfstate" {
  backend = "azurerm"
  config = {
    resource_group_name  = lower("${var.tags.app}-${var.tags.client}-${var.tags.environment}")
    storage_account_name = var.tfstate_storage_account_name
    container_name       = "tfstate"
    key                  = "${var.tags.environment}.terraform.tfstate"
  }
}

data "azurerm_resource_group" "base" {
  name     = lower("${var.tags.app}-${var.tags.client}-${var.tags.environment}")
}

provider "azurerm" {
  features {}
}
