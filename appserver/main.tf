# Network
resource "azurerm_subnet" "network" {
  name                 = "clouderp-network-internal"
  resource_group_name = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  # Make 10.10.10.0/24 -> 10.10.10.128/25 - Takes the upper half of the address space
  address_prefixes     = [ cidrsubnet(var.cloud_address_prefix, 1, 1) ]
}

resource "azurerm_network_interface" "appserver" {
  name                = "clouderp-appserver-nic"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.network.id
    private_ip_address_allocation = var.private_ip == "Dynamic" ? "Dynamic" : "Static"
    private_ip_address            = var.private_ip != "Dynamic" ? var.private_ip : null
  }
  tags = var.tags
}

# Firewall

resource "azurerm_network_security_group" "appserver" {
  name                = "clouderp-appserver-sg"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "appserver_rdp" {
  name                   = "clouderp-appserver-sg-rule-RDP"
  priority               = 100
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "Tcp"
  source_port_range      = "*"
  destination_port_range = "3389"
  # XXX: Check that indeed only VPN has access to it
  # TODO: Reference the VPN prefix
  source_address_prefixes     = [ var.cloud_address_prefix ]
  destination_address_prefix  = "*"
  resource_group_name = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.appserver.name
}

resource "azurerm_network_interface_security_group_association" "appserver" {
  network_interface_id      = azurerm_network_interface.appserver.id
  network_security_group_id = azurerm_network_security_group.appserver.id
}

# Virtual Machine

resource "azurerm_windows_virtual_machine" "appserver" {
  name                = "clouderp-appserver"
  computer_name       = "appserver"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  size                = var.size
  admin_username      = var.administrator_login
  admin_password      = var.administrator_password
  patch_mode          = "AutomaticByPlatform"
  # hotpatching_enabled = true
  # TODO: Termination notification
  network_interface_ids = [
    azurerm_network_interface.appserver.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    disk_size_gb         = var.disk_size_gb
    storage_account_type = var.storage_type
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  tags = var.tags
}
