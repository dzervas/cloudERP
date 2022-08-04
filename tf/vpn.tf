resource "azurerm_virtual_network" "vpn" {
  name                = "cloudERP-vpn-network"
  address_space       = [ var.vpn_address_space ]
  location            = azurerm_resource_group.base.location
  resource_group_name = azurerm_resource_group.base.name
  tags = var.tags
}

resource "azurerm_subnet" "vpn" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.base.name
  virtual_network_name = azurerm_virtual_network.vpn.name
  address_prefixes     = azurerm_virtual_network.vpn.address_space
  tags = var.tags
}

resource "azurerm_virtual_wan" "vpn" {
  name                = "cloudERP-vpn-vwan"
  resource_group_name = azurerm_resource_group.base.name
  location            = azurerm_resource_group.base.location
  tags = var.tags
}

resource "azurerm_virtual_hub" "vpn" {
  name                = "cloudERP-hub"
  resource_group_name = azurerm_resource_group.base.name
  location            = azurerm_resource_group.base.location
  virtual_wan_id      = azurerm_virtual_wan.vpn.id
  address_prefix      = "10.0.1.0/24"
  tags = var.tags
}

# TODO: Finish the gateway
resource "azurerm_vpn_gateway" "vpn" {
  name                = "cloudERP-vpng"
  location            = azurerm_resource_group.base.location
  resource_group_name = azurerm_resource_group.base.name
  virtual_hub_id      = azurerm_virtual_hub.vpn.id
  tags = var.tags
}
