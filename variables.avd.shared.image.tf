# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#####################################
# AZURE Shared Image Configuration ##
#####################################

variable "avd_shared_image" {
  description = "AVD Shared Image specific configuration."
  type = object({
    sig_image_name = optional(string)
    os_type        = optional(string)
    identifier = optional(object({
      publisher = optional(string)
      offer     = optional(string)
      sku       = optional(string)
    }))
  })
  default  = {}
  nullable = false
}
