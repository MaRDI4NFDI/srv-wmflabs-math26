terraform {
  required_version = ">= 1.6"

  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 3.0"
    }
    cloudvps = {
      source = "tofu.wmcloud.org/registry/cloudvps"
    }
  }
}

# Both read the OS_* environment variables set by deploy.
provider "openstack" {}
provider "cloudvps" {}
