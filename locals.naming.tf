# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

locals {
  # Naming locals/constants
  name_prefix = lower(var.name_prefix)
  name_suffix = lower(var.name_suffix)

  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, module.mod_scaffold_rg.*.resource_group_name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, module.mod_scaffold_rg.*.resource_group_location, [""]), 0)
  host_pool_name      = lower(coalesce(var.custom_avd_workspace_name, data.azurenoopsutils_resource_name.avd_host_pool.result))
  workspace_name      = lower(coalesce(var.custom_avd_workspace_name, data.azurenoopsutils_resource_name.virtual_desktop_workspace.result))
  avd_app_group_name  = lower(coalesce(var.custom_avd_workspace_name, data.azurenoopsutils_resource_name.avd_application_group.result))
}
