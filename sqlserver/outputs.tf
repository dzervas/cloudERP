output "fqdn" {
  value = length(var.databases) > 0 ? azurerm_mssql_server.sqlserver[0].fully_qualified_domain_name : null
}
