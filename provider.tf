//
// Copyright 2025 Canonical Ltd.  All rights reserved.
//

terraform {
  required_providers {
    juju = {
      version = "~> 0.19.0"
      source  = "juju/juju"
    }
  }
  required_version = "~> 1.6"
}

provider "juju" {}
