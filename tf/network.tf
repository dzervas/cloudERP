resource "azurerm_virtual_network" "network" {
  name                = "cloudERP-network-network"
  address_space       = [ var.vpn_address_space ]
  location            = azurerm_resource_group.base.location
  resource_group_name = azurerm_resource_group.base.name
  tags                = var.tags
}

resource "azurerm_subnet" "network" {
  name                 = "clourERP-network-internal"
  resource_group_name  = azurerm_resource_group.base.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = [ "10.80.80.128/25" ]
}

# resource "azurerm_virtual_wan" "network" {
#   name                = "cloudERP-network-vwan"
#   resource_group_name = azurerm_resource_group.base.name
#   location            = azurerm_resource_group.base.location
#   type                = "Basic"
#   tags                = var.tags
# }
