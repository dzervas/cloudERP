data "azurerm_monitor_diagnostic_categories" "vpn_remote" {
  count = length(var.log_workspace_id) > 0 ? 1 : 0
  resource_id = azurerm_virtual_network_gateway.vpn_remote.id
}

resource "azurerm_monitor_diagnostic_setting" "vpn_remote" {
  count = length(var.log_workspace_id) > 0 ? 1 : 0
  name                       = "clouderp-vpn-remote-analytics"
  target_resource_id         = azurerm_virtual_network_gateway.vpn_remote.id
  log_analytics_workspace_id = var.log_workspace_id


  dynamic "log" {
    for_each = data.azurerm_monitor_diagnostic_categories.vpn_remote[0].logs
    content {
      category = log.value
    }
  }

  metric {
    category = "AllMetrics"
  }
}
