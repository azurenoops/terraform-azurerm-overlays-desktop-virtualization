
##################################################
# AZURE VIRTUAL DESKTOP VMs
##################################################

module "mod_virtual_machine" {
  source  = "azurenoops/overlays-virtual-machine/azurerm"
  version = "~> 2.0"

  # Looping through the list of VM's to be deployed
  for_each = var.avd_vm_config != null ? var.avd_vm_config : {}

  # Resource Group, location, VNet and Subnet details
  existing_resource_group_name = local.resource_group_name
  location                     = local.location
  deploy_environment           = var.deploy_environment
  org_name                     = var.org_name
  workload_name                = var.workload_name

  # Lookup Network Information for VM deployment
  existing_virtual_network_resource_group_name = each.value.existing_virtual_network_resource_group_name
  existing_virtual_network_name                = each.value.existing_virtual_network_name
  existing_subnet_name                         = each.value.existing_subnet_name
  existing_network_security_group_name         = each.value.existing_network_security_group_name

  # This module supports a variety of pre-configured Linux and Windows distributions.
  # See the README.md file for more pre-defined Ubuntu, Centos, and RedHat images.
  # If you use gen2 distributions, please use gen2 images with supported VM sizes.
  # To generate a random admin password, specify 'disable_password_authentication = false' 
  # To use your own password, specify a valid password with the 'admin_password' parameter 
  # To produce an SSH key pair, specify 'generate_admin_ssh_key = true'
  # To use an existing key pair, set 'admin_ssh_key_data' to the path of a valid SSH public key.  
  os_type                         = each.value.os_type
  windows_distribution_name       = each.value.os_type == "windows" ? each.value.distribution_name : "windows2019dc"
  linux_distribution_name         = each.value.os_type == "linux" ? each.value.distribution_name : "ubuntu1804"
  virtual_machine_size            = each.value.virtual_machine_size
  disable_password_authentication = each.value.disable_password_authentication
  admin_username                  = each.value.admin_username
  admin_password                  = each.value.admin_password
  admin_ssh_key_data              = each.value.disable_password_authentication == true ? each.value.admin_ssh_key_data : null
  instances_count                 = each.value.instances_count

  # Virtual Machine Availability Set
  enable_vm_availability_set = each.value.enable_vm_availability_set

  # Virtual Machine Proximity Placement Group
  # The proximity placement group, Availability Set, and assigning a public IP address to VMs are all optional.
  # If you don't wish to utilize these arguments, delete them from the module. 
  enable_proximity_placement_group = each.value.enable_proximity_placement_group

  # Virtual Machine Public IP Address
  enable_public_ip_address = each.value.enable_public_ip_address

  # Virtual Machine Automatic Updates
  enable_automatic_updates = each.value.enable_automatic_updates

  # Virtual Machine License Type
  license_type = each.value.license_type

  # Custom Data for Virtual Machine
  custom_data = each.value.custom_data

  # Shared Image Gallery Image
  #source_image_id = var.avd_shared_image != null ? azurerm_shared_image.image.id : each.value.source_image_id

  # Custom Image
  custom_image = each.value.custom_image == null ? each.value.custom_image : null

  # Custom Image Plan
  custom_image_plan = each.value.custom_image == null ? each.value.custom_image.plan : null

  # Virtual Machine Private IP Address
  private_ip_address_allocation_type = each.value.private_ip_address_allocation_type # Static or Dynamic
  private_ip_address                 = each.value.private_ip_address

  # Network Security group port definitions for each Virtual Machine 
  # NSG association for all network interfaces to be added automatically.
  # If 'existing_network_security_group_name' is supplied, the module will use the existing NSG.
  nsg_inbound_rules = each.value.nsg_inbound_rules

  # Attach a managed data disk to a Windows/Linux virtual machine. 
  # Storage account types include: #'Standard_LRS', #'StandardSSD_ZRS', #'Premium_LRS', #'Premium_ZRS', #'StandardSSD_LRS', #'UltraSSD_LRS' (UltraSSD_LRS is only accessible in regions that support availability zones).
  # Create a new data drive - connect to the VM and execute diskmanagement or fdisk.
  data_disks = each.value.data_disks

  # Boot diagnostics are used to troubleshoot virtual machines by default. 
  # To use a custom storage account, supply a valid name for'storage_account_name'. 
  # Passing a 'null' value will use a Managed Storage Account to store Boot Diagnostics.
  enable_boot_diagnostics = each.value.enable_boot_diagnostics

  # (Optional) To activate Azure Monitoring and install log analytics agents 
  # (Optional) To save monitoring logs to storage, specify'storage_account_name'.    
  log_analytics_workspace_id = each.value.log_analytics_workspace_id

  # Deploy log analytics agents on a virtual machine. 
  # Customer id and primary shared key for Log Analytics workspace are required.
  deploy_log_analytics_agent                 = each.value.deploy_log_analytics_agent
  log_analytics_customer_id                  = each.value.log_analytics_customer_id
  log_analytics_workspace_primary_shared_key = each.value.log_analytics_workspace_primary_shared_key

  # Adding additional TAG's to your Azure resources
  add_tags = each.value.add_tags
}
