resource "azurerm_subnet" "vpn" {
  name                 = "GatewaySubnet"
  resource_group_name  = data.azurerm_resource_group.base.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = ["10.80.80.0/25"]
}

# Most code got from https://github.com/avinor/terraform-azurerm-vpn
resource "azurerm_public_ip" "vpn" {
  name                = "cloudERP-vpn-ip"
  location            = data.azurerm_resource_group.base.location
  resource_group_name = data.azurerm_resource_group.base.name

  allocation_method = "Dynamic"
  sku               = "Basic"

  tags = var.tags
}


resource "azurerm_virtual_network_gateway" "vpn_remote" {
  name                = "clouderp-vpn-gateway"
  location            = data.azurerm_resource_group.base.location
  resource_group_name = data.azurerm_resource_group.base.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Standard"

  ip_configuration {
    name                          = "clouderp-vpn-ip-config"
    public_ip_address_id          = azurerm_public_ip.vpn.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.vpn.id
  }

  vpn_client_configuration {
    address_space = ["10.80.40.0/24"]

    root_certificate {
      name = "VPN-Certificate"

      public_cert_data = var.vpn_public_key
    }

    vpn_client_protocols = ["SSTP", "IkeV2"]
  }

  custom_route {
    address_prefixes = [var.vpn_address_space]
  }

  tags = var.tags
}

data "azurerm_monitor_diagnostic_categories" "vpn_remote" {
  resource_id = azurerm_virtual_network_gateway.vpn_remote.id
}

resource "azurerm_monitor_diagnostic_setting" "vpn_remote" {
  name                       = "clouderp-vpn-remote-analytics"
  target_resource_id         = azurerm_virtual_network_gateway.vpn_remote.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logs.id


  dynamic "log" {
    for_each = data.azurerm_monitor_diagnostic_categories.vpn_remote.logs
    content {
      category = log.value
    }
  }

  metric {
    category = "AllMetrics"
  }
}