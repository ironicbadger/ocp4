terraform {
  required_providers {
    ignition = {
      source = "community-terraform-providers/ignition"
    }
    vsphere = {
      source = "hashicorp/vsphere"
    }
  }
  required_version = ">= 0.13"
}
