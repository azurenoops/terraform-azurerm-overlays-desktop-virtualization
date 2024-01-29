# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

############################
# AZURE App Configuration ##
############################

variable "avd_application_config" {
  description = "AVD Application specific configuration."
  type = map(object({
    app_name                     = optional(string)
    friendly_name                = optional(string)
    description                  = optional(string)
    path                         = optional(string)
    command_line_arguments       = optional(string)
    show_in_portal               = optional(bool, false)
    icon_path                    = optional(string)
    icon_index                   = optional(number)
    aad_group                    = optional(string)
    add_tags                     = optional(map(string))
  }))
  default = null
}
