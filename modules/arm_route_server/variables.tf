##################################################################################
# Route Server variables
##################################################################################
variable "location" {
  type    = string
}

variable "resource_group_name" {
  type    = string
}

variable "name" {
  type    = string
}

variable "subnet_id" {
  type    = string
}

variable "sku" {
  type    = string
  default = "Standard"
}

variable "public_ip_address_id" {
  type    = string
}

variable "branch_to_branch_traffic_enabled" {
  type    = string
}

variable "peer_1_name" {
  type    = string
}

variable "peer_1_asn" {
  type    = string
}

variable "peer_1_ip" {
  type    = string
}

variable "peer_2_name" {
  type    = string
}

variable "peer_2_asn" {
  type    = string
}

variable "peer_2_ip" {
  type    = string
}

variable "tags" {
  type    = map(string)
  default = {}
}