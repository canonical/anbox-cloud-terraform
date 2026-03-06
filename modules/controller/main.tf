//
// Copyright 2025 Canonical Ltd.  All rights reserved.
//

locals {
  controller_model_name = "anbox-controller"
  num_units             = var.enable_ha ? 3 : 1
}

resource "juju_model" "controller" {
  name = local.controller_model_name

  constraints = join(" ", var.constraints)

  config = {
    logging-config              = "<root>=INFO"
    update-status-hook-interval = "5m"
  }
}

resource "juju_ssh_key" "this" {
  count      = length(var.ssh_public_key) > 0 ? 1 : 0
  model_uuid = juju_model.controller.uuid
  payload    = trim(var.ssh_public_key, "\n")
}

resource "juju_application" "nats" {
  name = "nats"

  model_uuid  = juju_model.controller.uuid
  constraints = join(" ", var.constraints)

  charm {
    name    = "nats"
    channel = "2/stable"
    base    = local.base
  }

  machines = juju_machine.controller_node[*].machine_id

  // FIXME: Currently the provider has some issues with reconciling state using
  // the response from the JUJU APIs. This is done just to ignore the changes in
  // string values returned.
  lifecycle {
    ignore_changes = [constraints]
  }
}

resource "juju_application" "gateway" {
  name = "anbox-stream-gateway"

  model_uuid  = juju_model.controller.uuid
  constraints = join(" ", var.constraints)

  charm {
    name    = "anbox-stream-gateway"
    channel = var.channel
    base    = local.base
  }

  machines = juju_machine.controller_node[*].machine_id

  config = {
    snap_risk_level = local.risk
    ua_token        = var.ubuntu_pro_token
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

  model_uuid  = juju_model.controller.uuid
  constraints = join(" ", var.constraints)

  charm {
    name    = "anbox-cloud-dashboard"
    channel = var.channel
    base    = local.base
  }

  config = {
    snap_risk_level = local.risk
    ua_token        = var.ubuntu_pro_token
  }

  machines = juju_machine.controller_node[*].machine_id

  // FIXME: Currently the provider has some issues with reconciling state using
  // the response from the JUJU APIs. This is done just to ignore the changes in
  // string values returned.
  lifecycle {
    ignore_changes = [constraints]
  }
}

resource "juju_application" "ca" {
  name = "ca"

  model_uuid  = juju_model.controller.uuid
  constraints = join(" ", var.constraints)

  charm {
    name    = "self-signed-certificates"
    base    = local.base
    channel = "latest/stable"
  }

  machines = juju_machine.controller_node[*].machine_id

  // FIXME: Currently the provider has some issues with reconciling state using
  // the response from the JUJU APIs. This is done just to ignore the changes in
  // string values returned.
  lifecycle {
    ignore_changes = [constraints]
  }
}

resource "juju_integration" "gateway_nats" {
  model_uuid = juju_model.controller.uuid

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
  model_uuid = juju_model.controller.uuid

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
  model_uuid = juju_model.controller.uuid

  application {
    name     = juju_application.ca.name
    endpoint = "certificates"
  }

  application {
    name     = juju_application.nats.name
    endpoint = "ca-client"
  }
}

resource "juju_integration" "gateway_ca" {
  model_uuid = juju_model.controller.uuid

  application {
    name     = juju_application.ca.name
    endpoint = "certificates"
  }

  application {
    name     = juju_application.gateway.name
    endpoint = "certificates"
  }
}

resource "juju_integration" "dashboard_ca" {
  model_uuid = juju_model.controller.uuid

  application {
    name     = juju_application.ca.name
    endpoint = "certificates"
  }

  application {
    name     = juju_application.dashboard.name
    endpoint = "certificates"
  }
}

resource "juju_offer" "nats_offer" {
  model_uuid       = juju_model.controller.uuid
  application_name = juju_application.nats.name
  endpoints        = ["client"]
}

resource "juju_application" "cos_agent" {
  count = var.enable_cos ? 1 : 0
  name  = "grafana-agent"

  model_uuid = juju_model.controller.uuid

  charm {
    name = "grafana-agent"
    base = local.base
  }

  // FIXME: Currently the provider has some issues with reconciling state using
  // the response from the JUJU APIs. This is done just to ignore the changes in
  // string values returned.
  lifecycle {
    ignore_changes = [constraints]
  }
}

resource "juju_integration" "gateway_cos" {
  count      = var.enable_cos ? 1 : 0
  model_uuid = juju_model.controller.uuid

  application {
    name     = juju_application.gateway.name
    endpoint = "cos-agent"
  }

  application {
    name     = one(juju_application.cos_agent[*].name)
    endpoint = "cos-agent"
  }
}


resource "juju_machine" "controller_node" {
  model_uuid  = juju_model.controller.uuid
  count       = local.num_units
  base        = local.base
  name        = "anbox-controller-${count.index}"
  constraints = join(" ", var.constraints)
}
