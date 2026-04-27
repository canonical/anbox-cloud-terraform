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
    logging-config              = var.debug ? "<root>=DEBUG" : "<root>=INFO"
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
    base    = var.base
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
    base    = var.base
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
    base    = var.base
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
    base    = var.base
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
    base = var.base
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
  base        = var.base
  name        = "anbox-controller-${count.index}"
  constraints = join(" ", var.constraints)
}

resource "juju_application" "lb" {
  count = var.enable_lb ? 1 : 0
  name  = "anbox-stream-gateway-lb"

  model_uuid  = juju_model.controller.uuid
  constraints = join(" ", var.constraints)

  charm {
    name    = "haproxy"
    channel = "latest/stable"
    base    = var.base
  }

  machines = [juju_machine.controller_node[0].machine_id]

  expose {}

  config = {
    default_mode = "tcp"
    peering_mode = "active-active"
    ssl_cert     = "SELFSIGNED"
    ssl_key      = "SELFSIGNED"
    services     = <<-HAPROXY
      - service_name: app-anbox-stream-gateway
        service_host: "0.0.0.0"
        service_port: 8080
        service_options:
        - mode http
        server_options: check ssl verify none inter 2000 rise 2 fall 5 maxconn 4096
        crts: [DEFAULT]
      - service_name: app-anbox-cloud-dashboard
        service_host: "0.0.0.0"
        service_port: 8081
        service_options:
        - mode http
        server_options: check ssl verify none inter 2000 rise 2 fall 5 maxconn 4096
        crts: [DEFAULT]
      - service_name: api_http
        service_host: "0.0.0.0"
        service_port: 80
        service_options:
        - mode http
        - http-request redirect scheme https
      - service_name: api_https
        service_host: "0.0.0.0"
        service_port: 443
        service_options:
        - mode http
        - balance leastconn
        - acl path_start_api path_beg -i /1.0
        - acl path_start_ui path_beg -i /ui
        - use_backend app-anbox-stream-gateway if path_start_api
        - use_backend app-anbox-stream-gateway if path_start_ui
        - default_backend app-anbox-cloud-dashboard
        crts: [DEFAULT]
      HAPROXY
  }

  // FIXME: Currently the provider has some issues with reconciling state using
  // the response from the JUJU APIs. This is done just to ignore the changes in
  // string values returned.
  lifecycle {
    ignore_changes = [constraints]
  }
}

resource "juju_integration" "gateway_lb" {
  count      = var.enable_lb ? 1 : 0
  model_uuid = juju_model.controller.uuid

  application {
    name     = juju_application.gateway.name
    endpoint = "api"
  }

  application {
    name     = one(juju_application.lb[*].name)
    endpoint = "reverseproxy"
  }
}

resource "juju_integration" "dashboard_lb" {
  count      = var.enable_lb ? 1 : 0
  model_uuid = juju_model.controller.uuid

  application {
    name     = juju_application.dashboard.name
    endpoint = "reverseproxy"
  }

  application {
    name     = one(juju_application.lb[*].name)
    endpoint = "reverseproxy"
  }
}
