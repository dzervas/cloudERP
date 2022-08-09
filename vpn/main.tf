resource "azurerm_subnet" "vpn" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  # Make 10.10.10.0/24 -> 10.10.10.0/25 - Takes the lower half of the address space
  address_prefixes     = [ cidrsubnet(var.cloud_address_prefix, 1, 0) ]
}

# Most code got from https://github.com/avinor/terraform-azurerm-vpn
resource "azurerm_public_ip" "vpn" {
  name                = "clouderp-vpn-ip"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  allocation_method = "Dynamic"
  sku               = "Basic"

  tags = var.tags
}


resource "azurerm_virtual_network_gateway" "vpn_remote" {
  name                = "clouderp-vpn-gateway"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

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
    address_space = [ var.client_address_prefix ]

    root_certificate {
      name = "VPN-Certificate"

      public_cert_data = var.public_key
    }

    vpn_client_protocols = ["SSTP", "IkeV2"]
  }

  custom_route {
    address_prefixes = [ var.client_address_prefix ]
  }

  tags = var.tags
}
