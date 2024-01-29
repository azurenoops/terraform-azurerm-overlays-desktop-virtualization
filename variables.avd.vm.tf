

###############################
# AVD VM Configuration   ##
###############################

variable "avd_vm_config" {
  description = "AVD Virtual Machine configuration."
  type = map(object({
    distribution_name                            = optional(string, "windows2019dc")
    virtual_machine_size                         = optional(string, "standard_d2as_v4")
    aad_group_desktop                            = optional(string, null)
    os_type                                      = optional(string, "Windows")
    disable_password_authentication              = optional(bool, false)
    admin_ssh_key_data                           = optional(string, null)
    admin_username                               = optional(string, "azureadmin")
    admin_password                               = optional(string, null)
    instances_count                              = optional(number, 0)
    enable_proximity_placement_group             = optional(bool, false)
    enable_vm_availability_set                   = optional(bool, false)
    enable_public_ip_address                     = optional(bool, false)
    enable_automatic_updates                     = optional(bool, false)
    existing_network_security_group_name         = optional(string, null)
    license_type                                 = optional(string, "None")
    private_ip_address_allocation_type           = optional(string, "Dynamic")
    private_ip_address                           = optional(list(string), null)
    existing_virtual_network_name                = optional(string, null)
    existing_virtual_network_resource_group_name = optional(string, null)
    existing_subnet_name                         = optional(string, null)
    source_image_id                              = optional(string, null)
    custom_data                                  = optional(string, null)
    custom_image = optional(object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
      plan = object({
        name      = string
        product   = string
        publisher = string
      })
    }), null)
    nsg_inbound_rules = optional(list(object({
      name                   = optional(string)
      destination_port_range = optional(string)
      source_address_prefix  = optional(string)
    })), [])
    enable_boot_diagnostics = optional(bool, false)
    data_disks = optional(list(object({
      name                      = optional(string)
      caching                   = optional(string)
      create_option             = optional(string)
      disk_size_gb              = optional(number)
      lun                       = optional(number)
      managed_disk_type         = optional(string)
      storage_account_type      = optional(string)
      write_accelerator_enabled = optional(bool)
    })), [])
    deploy_log_analytics_agent                 = optional(bool, false)
    log_analytics_workspace_id                 = optional(string, null)
    log_analytics_customer_id                  = optional(string, null)
    log_analytics_workspace_primary_shared_key = optional(string, null)
    add_tags                                   = optional(map(string))
  }))
  default = null
}
