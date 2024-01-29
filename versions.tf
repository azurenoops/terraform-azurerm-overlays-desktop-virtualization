# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

terraform {
  required_version = ">= 1.3"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.69"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.47"
    } 
    azurenoopsutils = {
      source  = "azurenoops/azurenoopsutils"
      version = "~> 1.0.4"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.10"
    }
  }
}
