//
// Copyright 2025 Canonical Ltd.  All rights reserved.
//

locals {
  controller_model_name = "anbox-registry"
  num_units             = var.enable_ha ? 3 : 1
}

resource "juju_model" "registry" {
  name = local.controller_model_name

  constraints = join(" ", var.constraints)

  config = {
    logging-config              = "<root>=INFO"
    update-status-hook-interval = "5m"
  }
}


resource "juju_application" "aar" {
  name = "aar"

  model       = juju_model.registry.name
  constraints = join(" ", var.constraints)

  charm {
    name    = "aar"
    channel = var.channel
    base    = local.base
  }

  units = local.num_units

  config = {
    ua_token        = var.ubuntu_pro_token
    snap_risk_level = local.risk
  }

  // FIXME: Currently the provider has some issues with reconciling state using
  // the response from the JUJU APIs. This is done just to ignore the changes in
  // string values returned.
  lifecycle {
    ignore_changes = [constraints]
  }
}

resource "juju_offer" "client_offer" {
  model            = juju_model.registry.name
  application_name = juju_application.aar.name
  endpoint         = "client"
}

resource "juju_offer" "publisher_offer" {
  model            = juju_model.registry.name
  application_name = juju_application.aar.name
  endpoint         = "publisher"
}
