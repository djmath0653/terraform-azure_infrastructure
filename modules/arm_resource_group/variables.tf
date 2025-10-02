variable "name" {
  description = "Freeform input resource group name."
  type        = string
  default     = null
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to resources (inclusive)"
  type        = map(string)
}
