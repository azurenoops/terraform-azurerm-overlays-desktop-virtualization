# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

####################################
# Generic naming Configuration    ##
####################################
variable "name_prefix" {
  description = "Optional prefix for the generated name"
  type        = string
  default     = ""
}

variable "name_suffix" {
  description = "Optional suffix for the generated name"
  type        = string
  default     = ""
}

variable "use_naming" {
  description = "Use the Azure NoOps naming provider to generate default resource name. `storage_account_custom_name` override this if set. Legacy default name is used if this is set to `false`."
  type        = bool
  default     = false
}

# Custom naming override
variable "custom_resource_group_name" {
  description = "The name of the custom resource group to create. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables."
  type        = string
  default     = null
}

variable "workspace_custom_name" {
  description = "Custom Azure Virtual Desktop workspace name, generated if not set."
  type        = string
  default     = ""
}

variable "host_pool_custom_name" {
  description = "Custom Azure Virtual Desktop host pool name, generated if not set."
  type        = string
  default     = ""
}

variable "application_group_custom_name" {
  description = "Custom Azure Virtual Desktop Application Group name, generated if not set."
  type        = string
  default     = ""
}

variable "scaling_plan_custom_name" {
  description = "Custom Azure Virtual Desktop Scaling Plan name, generated if not set."
  type        = string
  default     = ""
}