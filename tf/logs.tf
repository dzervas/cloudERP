resource "azurerm_log_analytics_workspace" "logs" {
  name                = "clouderp-logs"
  location            = azurerm_resource_group.base.location
  resource_group_name = azurerm_resource_group.base.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
