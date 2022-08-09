data "azurerm_monitor_diagnostic_categories" "appserver" {
  count = length(var.log_workspace_id) > 0 ? 1 : 0
  resource_id = azurerm_windows_virtual_machine.appserver.id
}

resource "azurerm_monitor_diagnostic_setting" "appserver" {
  count = length(var.log_workspace_id) > 0 ? 1 : 0
  name                       = "clouderp-appserver-vm-analytics"
  target_resource_id         = azurerm_windows_virtual_machine.appserver.id
  log_analytics_workspace_id = var.log_workspace_id

  dynamic "log" {
    for_each = data.azurerm_monitor_diagnostic_categories.appserver[0].logs
    content {
      category = log.value
    }
  }

  metric {
    category = "AllMetrics"
  }
}
