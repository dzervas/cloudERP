# Network

resource "azurerm_network_interface" "appserver" {
  name                = "clouderp-appserver-nic"
  location            = azurerm_resource_group.base.location
  resource_group_name = azurerm_resource_group.base.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.network.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.80.80.200"
  }
  tags = var.tags
}

# Firewall

resource "azurerm_network_security_group" "appserver" {
  name                = "clouderp-appserver-sg"
  location            = azurerm_resource_group.base.location
  resource_group_name = azurerm_resource_group.base.name
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
  source_address_prefixes     = [var.vpn_address_space]
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.base.name
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
  resource_group_name = azurerm_resource_group.base.name
  location            = azurerm_resource_group.base.location
  size                = var.appserver_size
  admin_username      = var.appserver_administrator_login
  admin_password      = var.appserver_administrator_password
  patch_mode          = "AutomaticByPlatform"
  # hotpatching_enabled = true
  # TODO: Termination notification
  network_interface_ids = [
    azurerm_network_interface.appserver.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    disk_size_gb         = var.appserver_disk_size_gb
    storage_account_type = var.appserver_storage_type
  }

  source_image_reference {
    publisher = var.appserver_image_publisher
    offer     = var.appserver_image_offer
    sku       = var.appserver_image_sku
    version   = var.appserver_image_version
  }

  tags = var.tags
}

# Backups

resource "azurerm_recovery_services_vault" "appserver" {
  name                = "clouderp-appserver-vault"
  location            = azurerm_resource_group.base.location
  resource_group_name = azurerm_resource_group.base.name
  sku                 = "Standard"
  storage_mode_type   = "LocallyRedundant"
}

resource "azurerm_backup_policy_vm" "appserver" {
  name                = "clouderp-appserver-backup"
  resource_group_name = azurerm_resource_group.base.name
  recovery_vault_name = azurerm_recovery_services_vault.appserver.name

  timezone = "GTB Standard Time" # Europe/Athens https://jackstromberg.com/2017/01/list-of-time-zones-consumed-by-azure/

  backup {
    frequency = "Daily"
    time      = "20:00"
  }

  retention_daily {
    count = 7
  }

  retention_weekly {
    count    = 4
    weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday" ]
  }

  retention_monthly {
    count    = 3
    weekdays = ["Monday"]
    weeks    = ["First", "Second", "Third", "Fourth"]
  }
}

# Logging

data "azurerm_monitor_diagnostic_categories" "appserver" {
  resource_id = azurerm_windows_virtual_machine.appserver.id
}

resource "azurerm_monitor_diagnostic_setting" "appserver" {
  name                       = "clouderp-appserver-vm-analytics"
  target_resource_id         = azurerm_windows_virtual_machine.appserver.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logs.id

  dynamic "log" {
    for_each = data.azurerm_monitor_diagnostic_categories.appserver.logs
    content {
      category = log.value
    }
  }

  metric {
    category = "AllMetrics"
  }
}
