//
// Copyright 2025 Canonical Ltd.  All rights reserved.
//

terraform {
  required_providers {
    juju = {
      version = "~> 0.18.0"
      source  = "juju/juju"
    }
  }
  required_version = "~> 1.6"
}

locals {
  base           = "ubuntu@22.04"
  _channel_split = split("/", var.channel)
  risk           = element(local._channel_split, length(local._channel_split) - 1)
}

