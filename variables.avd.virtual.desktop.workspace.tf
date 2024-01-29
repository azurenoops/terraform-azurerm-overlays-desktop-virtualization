# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

##################################
# AZURE Workspace Configuration ##
##################################

variable "avd_workspace_config" {
  description = "AVD Workspace specific configuration."
  type = object({
    friendly_name                         = optional(string)
    description                           = optional(string)
    public_network_access_enabled         = optional(bool)
    enable_private_endpoint               = optional(bool)
    existing_private_dns_zone             = optional(string)
    existing_private_virtual_network_name = optional(string)
    existing_private_subnet_name          = optional(string)
    add_tags                              = optional(map(string))
  })
  default  = {}
  nullable = false
}
