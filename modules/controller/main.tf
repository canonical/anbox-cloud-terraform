//
// Copyright 2025 Canonical Ltd.  All rights reserved.
//

locals {
  controller_model_name = "anbox-controller"
}

resource "juju_model" "controller" {
  name = local.controller_model_name

  constraints = join(" ", var.constraints)

  config = {
    logging-config              = "<root>=INFO"
    update-status-hook-interval = "5m"
  }
}


resource "juju_application" "nats" {
  name = "nats"

  model       = juju_model.controller.name
  constraints = join(" ", var.constraints)

  charm {
    name    = "nats"
    channel = "latest/stable"
    base    = local.base
  }

  units = 1

  // FIXME: Currently the provider has some issues with reconciling state using
  // the response from the JUJU APIs. This is done just to ignore the changes in
  // string values returned.
  lifecycle {
    ignore_changes = [constraints]
  }
}

resource "juju_application" "gateway" {
  name = "anbox-stream-gateway"

  model       = juju_model.controller.name
  constraints = join(" ", var.constraints)

  charm {
    name    = "anbox-stream-gateway"
    channel = var.channel
    base    = local.base
  }

  units = 1

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

resource "juju_application" "dashboard" {
  name = "anbox-cloud-dashboard"

  model       = juju_model.controller.name
  constraints = join(" ", var.constraints)

  charm {
    name    = "anbox-cloud-dashboard"
    channel = var.channel
    base    = local.base
  }

  config = {
    ua_token        = var.ubuntu_pro_token
    snap_risk_level = local.risk
  }

  units = 1

  // FIXME: Currently the provider has some issues with reconciling state using
  // the response from the JUJU APIs. This is done just to ignore the changes in
  // string values returned.
  lifecycle {
    ignore_changes = [constraints]
  }
}

resource "juju_application" "ca" {
  name = "ca"

  model       = juju_model.controller.name
  constraints = join(" ", var.constraints)

  charm {
    name    = "easyrsa"
    base    = local.base
    channel = "latest/stable"
  }

  units = 1

  // FIXME: Currently the provider has some issues with reconciling state using
  // the response from the JUJU APIs. This is done just to ignore the changes in
  // string values returned.
  lifecycle {
    ignore_changes = [constraints]
  }
}

resource "juju_integration" "gateway_nats" {
  model = juju_model.controller.name

  application {
    name     = juju_application.gateway.name
    endpoint = "nats"
  }

  application {
    name     = juju_application.nats.name
    endpoint = "client"
  }
}

resource "juju_integration" "dashboard_gateway" {
  model = juju_model.controller.name

  application {
    name     = juju_application.gateway.name
    endpoint = "client"
  }

  application {
    name     = juju_application.dashboard.name
    endpoint = "gateway"
  }
}


resource "juju_integration" "nats_ca" {
  model = juju_model.controller.name

  application {
    name     = juju_application.ca.name
    endpoint = "client"
  }

  application {
    name     = juju_application.nats.name
    endpoint = "ca-client"
  }
}

resource "juju_integration" "gateway_ca" {
  model = juju_model.controller.name

  application {
    name     = juju_application.ca.name
    endpoint = "client"
  }

  application {
    name     = juju_application.gateway.name
    endpoint = "certificates"
  }
}

resource "juju_integration" "dashboard_ca" {
  model = juju_model.controller.name

  application {
    name     = juju_application.ca.name
    endpoint = "client"
  }

  application {
    name     = juju_application.dashboard.name
    endpoint = "certificates"
  }
}

resource "juju_offer" "nats_offer" {
  model            = juju_model.controller.name
  application_name = juju_application.nats.name
  endpoint         = "client"
}
