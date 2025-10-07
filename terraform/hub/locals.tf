locals {
  lower_fw_vm_name      = lower(var.fw_vm_name)
  
  workspace_resource_id = "/subscriptions/${var.log_workspace_sub_id}/resourceGroups/${var.log_workspace_rg}/providers/Microsoft.OperationalInsights/workspaces/${var.log_workspace_name}"
}
