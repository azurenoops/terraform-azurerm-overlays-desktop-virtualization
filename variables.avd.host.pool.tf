# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

##################################
# AZURE Host Pool Configuration ##
##################################

variable "host_pool_type" {
  description = "The type of the host pool. Valid values are Personal or Pooled."
  type    = string
  default = "Pooled"
}

variable "host_pool_load_balancer_type" {
  description = "The type of the load balancer. Valid values are BreadthFirst or DepthFirst."
  type    = string
  default = "BreadthFirst"
}

variable "host_pool_validate_environment" {
  description = "Validate the environment before creating the host pool. If set to true, the environment will be validated before creating the host pool. If set to false, the environment will not be validated before creating the host pool. Default is false."
  type    = bool
  default = false
}

variable "start_vm_on_connect" {
  description = "Start the VM on connect. If set to true, the VM will be started on connect. If set to false, the VM will not be started on connect. Default is false."
  type    = bool
  default = false
}

variable "host_pool_max_sessions_allowed" {
  description = "The maximum number of sessions allowed on the host pool. Default is 999999."
  type    = number
  default = 999999
}

variable "expiration_date" {
  description = "The expiration date of the registration info. Default is 1 hour from now."
  type    = string
  default = timeadd(format("%sT00:00:00Z", formatdate("YYYY-MM-DD", timestamp())), "3600m")  
}

variable "scheduled_agent_updates" {
  description = "The scheduled agent updates configuration for hosted pool."
  type = map(object({
    enabled     = bool
    day_of_week = number
    hour_of_day = number
  }))
  default = null
}