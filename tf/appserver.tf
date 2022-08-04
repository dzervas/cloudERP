# Network

resource "azurerm_network_interface" "appserver" {
  name                = "cloudERP-nic"
  location            = azurerm_resource_group.base.location
  resource_group_name = azurerm_resource_group.base.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vpn.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Firewall

resource "azurerm_network_security_group" "appserver" {
  name                = "cloudERP-appserver"
  location            = azurerm_resource_group.base.location
  resource_group_name = azurerm_resource_group.base.name
}

resource "azurerm_network_security_rule" "appserver-rdp" {
  name                        = "cloudERP-appserver-RDP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  # XXX: Check that indeed only VPN has access to it
  # TODO: Reference the VPN prefix
  source_address_prefixes     = [ var.vpn_address_space ]
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.base.name
  network_security_group_name = azurerm_network_security_group.appserver.name
}

# Virtual Machine

resource "azurerm_windows_virtual_machine" "appserver" {
  name                = "cloudERP-appserver"
  computer_name = "appserver"
  resource_group_name = azurerm_resource_group.base.name
  location            = azurerm_resource_group.base.location
  size                = var.appserver_size
  admin_username      = var.appserver_administrator_login
  admin_password      = var.appserver_administrator_password
  patch_mode = "AutomaticByPlatform"
  hotpatching_enabled = true
  # TODO: Termination notification
  network_interface_ids = [
    azurerm_network_interface.appserver.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    disk_size_gb = var.appserver_disk_size_gb
    storage_account_type = var.appserver_storage_type
  }

  source_image_reference {
    publisher = var.appserver_image_publisher
    offer     = var.appserver_image_offer
    sku       = var.appserver_image_sku
    version   = var.appserver_image_version
  }

  tags = {
    app = "cloudERP"
    environment = var.environment
  }
}
