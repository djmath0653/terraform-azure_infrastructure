locals {
  workspace_resource_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.log_workspace_rg}/providers/Microsoft.OperationalInsights/workspaces/${var.log_workspace_name}"
}
