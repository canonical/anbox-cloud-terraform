terraform {
  required_providers {
    juju = {
      version = "~> 0.10.0"
      source  = "juju/juju"
    }
  }
}

locals {
  base = "ubuntu@22.04"
}
