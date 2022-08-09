resource "azurerm_recovery_services_vault" "appserver" {
  count               = var.enable_backup ? 1 : 0
  name                = "clouderp-appserver-vault"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"
  storage_mode_type   = "LocallyRedundant"
}

resource "azurerm_backup_policy_vm" "appserver" {
  count               = var.enable_backup ? 1 : 0
  name                = "clouderp-appserver-backup"
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.appserver[0].name

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
    weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
  }

  retention_monthly {
    count    = 3
    weekdays = ["Monday"]
    weeks    = ["First", "Second", "Third", "Fourth"]
  }
}
