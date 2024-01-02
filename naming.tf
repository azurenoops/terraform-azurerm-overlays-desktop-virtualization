# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#------------------------------------------------------------
# Azure NoOps Naming - This should be used on all resource naming
# https://registry.terraform.io/providers/azurenoops/azurenoopsutils/latest/docs
#------------------------------------------------------------
data "azurenoopsutils_resource_name" "avd_host_pool" {
  name          = var.workload_name
  resource_type = "azurerm_resource_group"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azure_region_lookup.location_short : var.location]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "host-pool"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "virtual_desktop_workspace" {
  name          = var.workload_name
  resource_type = "azurerm_resource_group"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azure_region_lookup.location_short : var.location]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "ws"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}

data "azurenoopsutils_resource_name" "avd_application_group" {
  name          = var.workload_name
  resource_type = "azurerm_resource_group"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azure_region_lookup.location_short : var.location]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix, var.use_naming ? "" : "avd"])
  use_slug      = var.use_naming
  clean_input   = true
  separator     = "-"
}
