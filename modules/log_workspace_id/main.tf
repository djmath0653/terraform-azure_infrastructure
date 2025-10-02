data "azurerm_log_analytics_workspace" "logs" {
  name                = var.log_workspace_name
  resource_group_name = var.log_workspace_rg
}