# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

##################################
# AZURE App Group Configuration ##
##################################

variable "avd_application_group_config" {
  description = "AVD Application Group specific configuration."
  type = object({
    type                         = optional(string, "Desktop")
    add_tags                     = optional(map(string))
  })
  default  = null
}
