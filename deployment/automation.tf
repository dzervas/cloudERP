data "azurerm_client_config" "current" {}

resource "azurerm_automation_account" "automation" {
  name                = "clouderp-automation-account"
  location            = data.azurerm_resource_group.base.location
  resource_group_name = data.azurerm_resource_group.base.name
  sku_name            = "Basic"

  tags = var.tags
}

resource "azurerm_key_vault" "automation" {
  name                        = "clouderp-auto-vault"
  location                    = data.azurerm_resource_group.base.location
  resource_group_name         = data.azurerm_resource_group.base.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 14
  enabled_for_disk_encryption = false
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    certificate_permissions = ["Backup", "Create", "Delete", "Get", "Import", "List", "Update", "GetIssuers", "DeleteIssuers", "ListIssuers", "ManageIssuers", "SetIssuers"]
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_key_vault_certificate_issuer" "automation" {
  name          = "clouderp-auto-issuer"
  org_id        = "CloudERP"
  key_vault_id  = azurerm_key_vault.automation.id
  provider_name = "OneCertV2-PrivateCA"

  admin {
    email_address = "dzervas@dzervas.gr"
    first_name    = "Dimitris"
    last_name     = "Zervas"
    phone         = "+30 6970655809"
  }
}

resource "azurerm_key_vault_certificate" "automation" {
  count        = length(var.vpn_users)
  name         = var.vpn_users[count.index]
  key_vault_id = azurerm_key_vault.automation.id

  certificate_policy {
    issuer_parameters {
      name = azurerm_key_vault_certificate_issuer.automation.name
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      # Server Authentication = 1.3.6.1.5.5.7.3.1
      # Client Authentication = 1.3.6.1.5.5.7.3.2
      extended_key_usage = ["1.3.6.1.5.5.7.3.2"]

      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject_alternative_names {
        dns_names = ["desktop"]
      }

      subject            = "CN=CloudERP VPN"
      validity_in_months = 24
    }
  }
}
