locals {
  # https://learn.microsoft.com/en-us/azure/virtual-desktop/service-principal-assign-roles?tabs=portal
  avd_service_principal_client_id = "9cdead84-a844-4324-93f2-b2e6bb768d07"
  avd_service_principal_object_id = try(coalesce(var.scaling_plan_config.role_assignment.principal_id, one(data.azuread_service_principal.avd_service_principal[*].object_id)), null)

  scaling_plan_role_assignment_enabled = var.scaling_plan_config.enabled && var.scaling_plan_config.role_assignment.enabled

  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_desktop_scaling_plan
  scaling_plan_role_definition = {
    name        = "AVD AutoScale"
    description = "AVD AutoScale Role."
    allowed_actions = [
      "Microsoft.Insights/eventtypes/values/read",
      "Microsoft.Compute/virtualMachines/deallocate/action",
      "Microsoft.Compute/virtualMachines/restart/action",
      "Microsoft.Compute/virtualMachines/powerOff/action",
      "Microsoft.Compute/virtualMachines/start/action",
      "Microsoft.Compute/virtualMachines/read",
      "Microsoft.DesktopVirtualization/hostpools/read",
      "Microsoft.DesktopVirtualization/hostpools/write",
      "Microsoft.DesktopVirtualization/hostpools/sessionhosts/read",
      "Microsoft.DesktopVirtualization/hostpools/sessionhosts/write",
      "Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions/delete",
      "Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions/read",
      "Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions/sendMessage/action",
      "Microsoft.DesktopVirtualization/hostpools/sessionhosts/usersessions/read",
    ]
  }
}

# Locates unique AAD groups for application group for_each loop. 
locals {
  aad_group_list = var.avd_application_config != null ? distinct(values({ for k, v in var.avd_application_config : k => v.aad_group })) : ["${var.avd_vm_config.aad_group_desktop}"]
  applications   = var.avd_application_config != null ? var.avd_application_config : tomap({}) # Null is not accepted as for_each value, substituing for an empty map if null.
}
