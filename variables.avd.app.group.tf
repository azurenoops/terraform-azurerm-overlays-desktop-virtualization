# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

##################################
# AZURE App Group Configuration ##
##################################

variable "avd_application_group_config" {
  description = "AVD Application Group specific configuration."
  type = object({
    friendly_name                = optional(string)
    default_desktop_display_name = optional(string)
    description                  = optional(string)
    type                         = optional(string, "Desktop")
    extra_tags                   = optional(map(string))
  })
  default  = {}
  nullable = false
}