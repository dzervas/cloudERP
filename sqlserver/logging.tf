data "azurerm_monitor_diagnostic_categories" "sqlserver" {
  count = length(var.log_workspace_id) > 0 && length(var.databases) > 0 ? 1 : 0
  resource_id = azurerm_mssql_server.sqlserver[0].id
}

resource "azurerm_monitor_diagnostic_setting" "sqlserver" {
  count = length(var.log_workspace_id) > 0 && length(var.databases) > 0 ? 1 : 0
  name                       = "clouderp-sqlserver-server-analytics"
  target_resource_id         = azurerm_mssql_server.sqlserver[0].id
  log_analytics_workspace_id = var.log_workspace_id

  dynamic "log" {
    for_each = data.azurerm_monitor_diagnostic_categories.sqlserver[0].logs
    content {
      category = log.value
    }
  }

  metric {
    category = "AllMetrics"
  }
}

data "azurerm_monitor_diagnostic_categories" "sqlserver_database" {
  count = length(var.log_workspace_id) > 0 ? 1 : 0
  resource_id = azurerm_mssql_database.sqlserver[count.index].id
}

resource "azurerm_monitor_diagnostic_setting" "sqlserver_database" {
  count = length(var.log_workspace_id) > 0 ? 1 : 0
  name                       = "clouderp-sqlserver-database-analytics-${count.index}"
  target_resource_id         = azurerm_mssql_database.sqlserver[count.index].id
  log_analytics_workspace_id = var.log_workspace_id

  dynamic "log" {
    for_each = data.azurerm_monitor_diagnostic_categories.sqlserver_database[count.index].logs
    content {
      category = log.value
    }
  }

  metric {
    category = "AllMetrics"
  }
}
