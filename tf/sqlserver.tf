resource "azurerm_mssql_server" "sqlserver" {
  name                         = "clouderp-sqlserver"
  resource_group_name          = azurerm_resource_group.base.name
  location                     = azurerm_resource_group.base.location
  version                      = var.sqlserver_version
  administrator_login          = var.sqlserver_administrator_login
  administrator_login_password = var.sqlserver_administrator_password
  public_network_access_enabled = false

  tags = var.tags
}

resource "azurerm_mssql_database" "sqlserver" {
  count = length(var.sqlserver_databases)
  name           = "clouderp-${var.sqlserver_databases[count.index]}"
  server_id      = azurerm_mssql_server.sqlserver.id
  collation      = var.sqlserver_database_collation
  # license_type   = var.sqlserver_database_license
  sku_name       = var.sqlserver_database_sku
  storage_account_type = var.sqlserver_database_storage_type
  # TODO: Tinker this
  # auto_pause_delay_in_minutes = 10

  short_term_retention_policy {
    retention_days = var.sqlserver_database_retention_days
    backup_interval_in_hours = var.sqlserver_database_retention_interval
  }
  long_term_retention_policy {
    weekly_retention = var.sqlserver_database_retention_weeks
    monthly_retention = var.sqlserver_database_retention_months
    yearly_retention = "PT0S"
    week_of_year = 1
  }


  tags = var.tags
}

# Logging

data "azurerm_monitor_diagnostic_categories" "sqlserver" {
  resource_id = azurerm_mssql_server.sqlserver.id
}

resource "azurerm_monitor_diagnostic_setting" "sqlserver" {
  name                       = "clouderp-sqlserver-server-analytics"
  target_resource_id         = azurerm_mssql_server.sqlserver.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logs.id

  dynamic "log" {
    for_each = data.azurerm_monitor_diagnostic_categories.sqlserver.logs
    content {
      category = log
    }
  }

  metric {
    category = "AllMetrics"
  }
}

data "azurerm_monitor_diagnostic_categories" "sqlserver_database" {
  count = length(var.sqlserver_databases)
  resource_id = azurerm_mssql_database.sqlserver[count.index].id
}

resource "azurerm_monitor_diagnostic_setting" "sqlserver_database" {
  count = length(var.sqlserver_databases)
  name                       = "clouderp-sqlserver-database-analytics-${count.index}"
  target_resource_id         = azurerm_mssql_database.sqlserver[count.index].id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logs.id

  dynamic "log" {
    for_each = data.azurerm_monitor_diagnostic_categories.sqlserver_database[count.index].logs
    content {
      category = log
    }
  }

  metric {
    category = "AllMetrics"
  }
}
