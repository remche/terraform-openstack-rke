terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
    }
    openstack = {
      source = "terraform-providers/openstack"
    }
  }
  required_version = ">= 0.13"
}
