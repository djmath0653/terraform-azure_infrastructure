##################################################################################
# Virtual Network Gateway network 
##################################################################################
module "vpn_vng" {
  source = "../../modules/arm_virtual_network_gateway"

  location                            = module.resource_group.location
  name                                = var.vpn_vng_name
  sku                                 = var.vpn_vng_sku
  type                                = var.vpn_vng_type
  virtual_network_name                = module.virtual_network.vnet.name
  virtual_network_resource_group_name = module.resource_group.name
  subnet_id                           = module.virtual_network.subnet.GatewaySubnet.id
  public_ip_name                      = var.vpn_pip_name
  vpn_active_active_enabled           = true
  workspace_resource_id               = local.workspace_resource_id
  tags                                = var.tags
  local_network_gateways = {
    "01" = {
      name            = var.vpn_lng_name
      address_space   = var.vpn_lng_addess_space
      gateway_address = var.vpn_lng_ip_addess
      tags            = var.tags
      connection = {
        name       = var.vpn_connection_name
        type       = "IPsec"
        shared_key = "James1441"
        ipsec_policy = {
          dh_group         = "DHGroup24"
          ike_encryption   = "AES256"
          ike_integrity    = "SHA256"
          ipsec_encryption = "AES256"
          ipsec_integrity  = "SHA256"
          pfs_group        = "PFS2"
          sa_lifetime      = 27000
        }
      }
    }
  }
}
