output "ip" {
  description = "IP address for the App Server"
  value = azurerm_network_interface.appserver.private_ip_address
}
