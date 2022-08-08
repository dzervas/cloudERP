output "vpn_fqdn" {
  description = "FQDN for the VPN gateway"
  value       = azurerm_public_ip.vpn.fqdn
}

output "appserver_internal_ip" {
  description = "Internal IP address for the App Server in the VPN"
  value       = azurerm_network_interface.appserver.private_ip_address
}

output "sqlserver_internal_fqdn" {
  description = "FQDN for the SQL Server in the VPN"
  value       = azurerm_mssql_server.sqlserver.fully_qualified_domain_name
}
