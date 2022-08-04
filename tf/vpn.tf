resource "azurerm_virtual_network" "vpn" {
  name                = "cloudERP-vpn-network"
  address_space       = [ var.vpn_address_space ]
  location            = azurerm_resource_group.base.location
  resource_group_name = azurerm_resource_group.base.name
}

resource "azurerm_subnet" "vpn" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.base.name
  virtual_network_name = azurerm_virtual_network.vpn.name
  address_prefixes     = azurerm_virtual_network.vpn.address_space
}

resource "azurerm_virtual_wan" "vpn" {
  name                = "cloudERP-vpn-vwan"
  resource_group_name = azurerm_resource_group.base.name
  location            = azurerm_resource_group.base.location
}

resource "azurerm_virtual_hub" "vpn" {
  name                = "cloudERP-hub"
  resource_group_name = azurerm_resource_group.base.name
  location            = azurerm_resource_group.base.location
  virtual_wan_id      = azurerm_virtual_wan.vpn.id
  address_prefix      = "10.0.1.0/24"
}

# TODO: Finish the gateway
resource "azurerm_vpn_gateway" "vpn" {
  name                = "cloudERP-vpng"
  location            = azurerm_resource_group.base.location
  resource_group_name = azurerm_resource_group.base.name
  virtual_hub_id      = azurerm_virtual_hub.vpn.id
}
