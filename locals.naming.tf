# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, module.mod_scaffold_rg.*.resource_group_name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, module.mod_scaffold_rg.*.resource_group_location, [""]), 0)
  avd_workspace_name    = coalesce(var.workspace_custom_name, data.azurecaf_name.avd_workspace.result)
  avd_host_pool_name    = coalesce(var.host_pool_custom_name, data.azurecaf_name.avd_host_pool.result)
  avd_app_group_name    = coalesce(var.application_group_custom_name, data.azurecaf_name.avd_app_group.result)
  avd_scaling_plan_name = coalesce(var.scaling_plan_custom_name, data.azurecaf_name.avd_scaling_plan.result)
  }
