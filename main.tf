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

provider "azuread" {}

data "azurerm_resource_group" "base" {
  name = lower("${var.tags.app}-${var.tags.client}-${var.tags.environment}")
}

# Network

resource "azurerm_virtual_network" "network" {
  name                = "clouderp-vnet"
  address_space       = [ var.cloud_address_prefix ]
  location            = data.azurerm_resource_group.base.location
  resource_group_name = data.azurerm_resource_group.base.name
  tags                = var.tags
}

resource "azurerm_subnet" "network" {
  name                 = "clouderp-network-internal"
  resource_group_name  = data.azurerm_resource_group.base.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = ["10.80.80.128/25"]
}

# Automation

data "azurerm_client_config" "current" {}

resource "azurerm_automation_account" "automation" {
  name                = "clouderp-automation-account"
  location            = data.azurerm_resource_group.base.location
  resource_group_name = data.azurerm_resource_group.base.name
  sku_name            = "Basic"

  tags = var.tags
}

# Logging

resource "azurerm_log_analytics_workspace" "logs" {
  count               = var.enable_logging ? 1 : 0
  name                = "clouderp-logs"
  location            = data.azurerm_resource_group.base.location
  resource_group_name = data.azurerm_resource_group.base.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}


# Modules

module "vpn" {
  source = "./vpn"
  resource_group_name = data.azurerm_resource_group.base.name
  resource_group_location = data.azurerm_resource_group.base.location

  virtual_network_name = azurerm_virtual_network.network.name
  cloud_address_prefix = var.cloud_address_prefix
  client_address_prefix = var.client_address_prefix
  log_workspace_id = var.enable_logging ? azurerm_log_analytics_workspace.logs[0].id : ""

  tags = var.tags
}

module "appserver" {
  source = "./appserver"
  resource_group_name = data.azurerm_resource_group.base.name
  resource_group_location = data.azurerm_resource_group.base.location

  virtual_network_name  = azurerm_virtual_network.network.name
  cloud_address_prefix  = var.cloud_address_prefix
  log_workspace_id = var.enable_logging ? azurerm_log_analytics_workspace.logs[0].id : ""
  private_ip = cidrhost(var.cloud_address_prefix, 200)

  tags = var.tags
}

module "sqlserver" {
  source = "./sqlserver"
  resource_group_name = data.azurerm_resource_group.base.name
  resource_group_location = data.azurerm_resource_group.base.location

  # virtual_network_name  = azurerm_virtual_network.network.name
  # cloud_address_prefix  = var.cloud_address_prefix
  log_workspace_id = var.enable_logging ? azurerm_log_analytics_workspace.logs[0].id : ""

  databases = ["cloudERP-test-db"]

  tags = var.tags
}

# Budget
# TODO: Variable this

data "azurerm_subscription" "current" {
}

resource "azurerm_consumption_budget_resource_group" "budget" {
  name              = "clouderp-budget"
  resource_group_id = data.azurerm_resource_group.base.id

  amount     = 100
  time_grain = "Monthly"

  time_period {
    start_date = "2022-08-01T00:00:00Z"
  }

  filter {
    dimension {
      name = "SubscriptionID"
      values = [
        data.azurerm_subscription.current.id,
      ]
    }
  }

  notification {
    enabled        = true
    threshold      = 90.0
    operator       = "GreaterThanOrEqualTo"
    threshold_type = "Forecasted"

    contact_roles = [
      "Owner",
    ]
  }

  notification {
    enabled   = true
    threshold = 80.0
    operator  = "GreaterThan"

    contact_roles = [
      "Owner",
    ]
  }
}

# Outputs
output "vpn_fqdn" {
  description = "FQDN for the VPN gateway"
  value       = module.vpn.fqdn
}

output "appserver_ip" {
  description = "Internal IP address for the App Server in the VPN"
  value       = module.appserver.ip
}

output "sqlserver_fqdn" {
  description = "FQDN for the SQL Server in the VPN"
  value       = module.sqlserver.fqdn
}
