terraform {
  required_providers {
    juju = {
      version = "~> 0.11.0"
      source  = "juju/juju"
    }
  }
  required_version = "~> 1.6"
}

provider "juju" {}
