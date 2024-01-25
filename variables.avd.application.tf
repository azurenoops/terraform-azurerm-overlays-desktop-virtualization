# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

############################
# AZURE App Configuration ##
############################

variable "avd_application_config" {
  description = "AVD Application specific configuration."
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
