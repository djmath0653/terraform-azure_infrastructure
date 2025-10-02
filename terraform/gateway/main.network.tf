##################################################################################
# Virtual Network Gateway network 
##################################################################################
module "resource_group" {
  source = "../../modules/arm_resource_group"

  name     = var.rg_name
  location = var.location
  tags     = var.tags
}

module "virtual_network" {
  source = "../../modules/arm_virtual_network"

  resource_group_name  = module.resource_group.name
  location             = module.resource_group.location
  virtual_network_name = var.vnet_name
  address_space        = var.address_space
  subnets              = var.subnets
  route_tables         = var.route_tables
  peers                = var.peers
  tags                 = var.tags
  diagnostic_settings = {
    diag = {
      workspace_resource_id = local.workspace_resource_id
    }
  }
}