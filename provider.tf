terraform {
  required_providers {
    juju = {
      version = "~> 0.18.0"
      source  = "juju/juju"
    }
  }
  required_version = "~> 1.6"
}

provider "juju" {}
