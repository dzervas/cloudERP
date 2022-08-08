resource "azurerm_log_analytics_workspace" "logs" {
  name                = "clouderp-logs"
  location            = data.azurerm_resource_group.base.location
  resource_group_name = data.azurerm_resource_group.base.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
