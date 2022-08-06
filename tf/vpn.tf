# resource "azurerm_virtual_hub" "vpn" {
#   name                = "cloudERP-vpn-hub"
#   resource_group_name = azurerm_resource_group.base.name
#   location            = azurerm_resource_group.base.location
#   virtual_wan_id      = azurerm_virtual_wan.vpn.id
#   address_prefix      = var.vpn_address_space
#   tags                = var.tags
# }

# TODO: Finish the gateway
# resource "azurerm_vpn_gateway" "vpn" {
#   name                = "cloudERP-vpn-gateway"
#   location            = azurerm_resource_group.base.location
#   resource_group_name = azurerm_resource_group.base.name
#   virtual_hub_id      = azurerm_virtual_hub.vpn.id
#   # TODO: Make this basic
#   # sku                 = "Basic"
#   tags = var.tags
# }

resource "azurerm_subnet" "vpn" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.base.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = [ "10.80.80.0/25" ]
}

# Most code got from https://github.com/avinor/terraform-azurerm-vpn
resource "azurerm_public_ip" "vpn" {
  name                = "cloudERP-vpn-ip"
  location            = azurerm_resource_group.base.location
  resource_group_name = azurerm_resource_group.base.name
  domain_name_label   = lower("${var.tags.app}-${var.tags.client}-${var.tags.environment}")

  allocation_method = "Dynamic"
  sku               = "Basic"

  tags = var.tags
}

# resource "azurerm_monitor_diagnostic_setting" "gw_pip" {
#   count                      = var.log_analytics_workspace_id != null ? 1 : 0
#   name                       = "gw-pip-log-analytics"
#   target_resource_id         = azurerm_public_ip.gw.id
#   log_analytics_workspace_id = var.log_analytics_workspace_id

#   log {
#     category = "DDoSProtectionNotifications"

#     retention_policy {
#       enabled = false
#     }
#   }

#   log {
#     category = "DDoSMitigationFlowLogs"

#     retention_policy {
#       enabled = false
#     }
#   }

#   log {
#     category = "DDoSMitigationReports"

#     retention_policy {
#       enabled = false
#     }
#   }

#   metric {
#     category = "AllMetrics"

#     retention_policy {
#       enabled = false
#     }
#   }
# }

resource "azurerm_virtual_network_gateway" "vpn_remote" {
  name                = "CloudERP-vpn-gateway"
  location            = azurerm_resource_group.base.location
  resource_group_name = azurerm_resource_group.base.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    name                          = "CloudERP-vpn-ip-config"
    public_ip_address_id          = azurerm_public_ip.vpn.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.vpn.id
  }

  vpn_client_configuration {
    address_space = [ "10.80.40.0/24" ]

    root_certificate {
      name = "VPN-Certificate"

      public_cert_data = var.vpn_public_key
    }

    vpn_client_protocols = [ "SSTP" ]
  }

  tags = var.tags
}

# resource "azurerm_monitor_diagnostic_setting" "gw" {
#   count                      = var.log_analytics_workspace_id != null ? 1 : 0
#   name                       = "gw-analytics"
#   target_resource_id         = azurerm_virtual_network_gateway.gw.id
#   log_analytics_workspace_id = var.log_analytics_workspace_id

#   log {
#     category = "GatewayDiagnosticLog"

#     retention_policy {
#       enabled = false
#     }
#   }

#   log {
#     category = "TunnelDiagnosticLog"

#     retention_policy {
#       enabled = false
#     }
#   }

#   log {
#     category = "RouteDiagnosticLog"

#     retention_policy {
#       enabled = false
#     }
#   }

#   log {
#     category = "IKEDiagnosticLog"

#     retention_policy {
#       enabled = false
#     }
#   }

#   log {
#     category = "P2SDiagnosticLog"

#     retention_policy {
#       enabled = false
#     }
#   }

#   metric {
#     category = "AllMetrics"

#     retention_policy {
#       enabled = false
#     }
#   }
# }

resource "azurerm_local_network_gateway" "vpn_local" {
  name                = "CloudERP-vpn-gateway-local"
  location            = azurerm_resource_group.base.location
  resource_group_name = azurerm_resource_group.base.name
  gateway_address     = "10.80.40.100"
  address_space       = [ "10.80.40.0/24" ]

  tags = var.tags
}

resource "azurerm_virtual_network_gateway_connection" "local" {
  name                = "CloudERP-vpn-gateway-local-connection"
  location            = azurerm_resource_group.base.location
  resource_group_name = azurerm_resource_group.base.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpn_remote.id
  local_network_gateway_id   = azurerm_local_network_gateway.vpn_local.id

  # shared_key = var.local_networks[count.index].shared_key

  # ipsec_policy {
  #   dh_group         = var.local_networks[count.index].ipsec_policy.dh_group
  #   ike_encryption   = var.local_networks[count.index].ipsec_policy.ike_encryption
  #   ike_integrity    = var.local_networks[count.index].ipsec_policy.ike_integrity
  #   ipsec_encryption = var.local_networks[count.index].ipsec_policy.ipsec_encryption
  #   ipsec_integrity  = var.local_networks[count.index].ipsec_policy.ipsec_integrity
  #   pfs_group        = var.local_networks[count.index].ipsec_policy.pfs_group
  #   sa_datasize      = var.local_networks[count.index].ipsec_policy.sa_datasize
  #   sa_lifetime      = var.local_networks[count.index].ipsec_policy.sa_lifetime
  # }

  tags = var.tags
}
