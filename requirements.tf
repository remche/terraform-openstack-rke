terraform {
  required_version = ">=0.12"
  required_providers {
    local     = ">=1.4.0"
    null      = ">=2.1.2"
    openstack = ">=1.24.0"
    rke       = ">=1.0.0"
  }
}
