output "fqdn" {
  description = "FQDN for the VPN gateway"
  value       = azurerm_public_ip.vpn.fqdn
}
