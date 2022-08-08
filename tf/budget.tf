data "azurerm_subscription" "current" {
}

resource "azurerm_consumption_budget_resource_group" "budget" {
  name              = "clouderp-budget"
  resource_group_id = data.azurerm_resource_group.base.id

  amount     = 100
  time_grain = "Monthly"

  time_period {
    start_date = "2022-08-01T00:00:00Z"
  }

  filter {
    dimension {
      name = "SubscriptionID"
      values = [
        data.azurerm_subscription.current.id,
      ]
    }
  }

  notification {
    enabled        = true
    threshold      = 90.0
    operator       = "GreaterThanOrEqualTo"
    threshold_type = "Forecasted"

    contact_roles = [
      "Owner",
    ]
  }

  notification {
    enabled   = false
    threshold = 100.0
    operator  = "GreaterThan"

    contact_roles = [
      "Owner",
    ]
  }
}
