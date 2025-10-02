resource "azurerm_monitor_diagnostic_setting" "nsg" {
  count = length(azurerm_network_security_group.nsg)

  name                           = "diag-${var.subnet_name}-nsg"
  target_resource_id             = azurerm_network_security_group.nsg[count.index].id
  eventhub_authorization_rule_id = var.diagnostic_settings["diag"].event_hub_authorization_rule_resource_id
  # log_analytics_destination_type = each.value.log_analytics_destination_type
  log_analytics_destination_type = null
  log_analytics_workspace_id     = var.diagnostic_settings["diag"].workspace_resource_id
  partner_solution_id            = var.diagnostic_settings["diag"].marketplace_partner_resource_id
  storage_account_id             = var.diagnostic_settings["diag"].storage_account_resource_id

  enabled_log {
    category = "NetworkSecurityGroupEvent"
  }

  enabled_log {
    category = "NetworkSecurityGroupRuleCounter"
  }
}