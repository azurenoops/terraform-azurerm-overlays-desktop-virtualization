# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#------------------------------------------------------------
# Azure NoOps Naming - This should be used on all resource naming
# https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs
#------------------------------------------------------------
data "azurenoopsutils_resource_name" "avd_workspace" {
  name          = var.workload_name
  resource_type = "azurerm_virtual_desktop_workspace"
  prefixes      = var.name_prefix != "" ? ["vdws"] : [local.name_prefix, "vdws", var.org_name, var.use_location_short_name ? module.mod_azure_region_lookup.location_short : var.location]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "host-pool"])
  use_slug      = false
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "avd_host_pool" {
  name          = var.workload_name
  resource_type = "azurerm_virtual_desktop_host_pool"
  prefixes      = var.name_prefix != "" ? ["vdpool"] : [local.name_prefix, "vdpool", var.org_name, var.use_location_short_name ? module.mod_azure_region_lookup.location_short : var.location]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "ws"])
  use_slug      = false
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "avd_application_group" {
  name          = var.workload_name
  resource_type = "azurerm_virtual_desktop_application_group"
  prefixes      = var.name_prefix != "" ? ["vdag"] : [local.name_prefix, "vdag", var.org_name, var.use_location_short_name ? module.mod_azure_region_lookup.location_short : var.location]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "avd"])
  use_slug      = false
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "avd_scaling_plan" {
  name          = var.workload_name
  resource_type = "azurerm_resource_group"
  prefixes      = var.name_prefix != "" ? ["vdscaling"] : [local.name_prefix, "vdscaling", var.org_name, var.use_location_short_name ? module.mod_azure_region_lookup.location_short : var.location]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "avd"])
  use_slug      = false
  clean_input   = true
  separator     = "-"
}