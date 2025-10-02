##################################################################################
# Express Route Gateway 
##################################################################################
module "expressrt_vng" {
  source = "../../modules/arm_virtual_network_gateway"

  location                            = module.resource_group.location
  name                                = var.er_vng_name
  sku                                 = var.er_vng_sku
  type                                = var.er_vng_type
  virtual_network_name                = module.virtual_network.vnet.name
  virtual_network_resource_group_name = module.resource_group.name
  subnet_id                           = module.virtual_network.subnet.GatewaySubnet.id
  public_ip_name                      = var.er_pip_name
  vpn_active_active_enabled           = false
  workspace_resource_id               = local.workspace_resource_id
  tags                                = var.tags
}
