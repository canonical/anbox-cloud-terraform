terraform {
  required_providers {
    juju = {
      version = "~> 0.12.0"
      source  = "juju/juju"
    }
  }
  required_version = "~> 1.6"
}

locals {
  base = "ubuntu@22.04"
}
