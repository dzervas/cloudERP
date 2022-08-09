resource "azurerm_mssql_server" "sqlserver" {
  count                         = length(var.databases) > 0 ? 1 : 0
  name                          = "clouderp-sqlserver"
  resource_group_name           = var.resource_group_name
  location                      = var.resource_group_location
  version                       = var.mssql_version
  administrator_login           = var.administrator_login
  administrator_login_password  = var.administrator_password
  public_network_access_enabled = false

  tags = var.tags
}

resource "azurerm_mssql_database" "sqlserver" {
  count     = length(var.databases)
  name      = "clouderp-${var.databases[count.index]}"
  server_id = azurerm_mssql_server.sqlserver[0].id
  collation = var.database_collation
  # license_type   = var.sqlserver_database_license
  sku_name             = var.database_sku
  storage_account_type = var.database_storage_type
  # TODO: Disable external access
  # TODO: Tinker this
  # auto_pause_delay_in_minutes = 10

  # TODO: Enable differential backup & compression
  # TODO: Use enable_backup
  short_term_retention_policy {
    retention_days           = var.database_retention_days
    backup_interval_in_hours = var.database_retention_interval
  }
  long_term_retention_policy {
    weekly_retention  = var.database_retention_weeks
    monthly_retention = var.database_retention_months
    yearly_retention  = "PT0S"
    week_of_year      = "1"
  }


  tags = var.tags
}
