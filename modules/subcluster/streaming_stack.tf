resource "juju_application" "nats" {
  count = var.deploy_streaming_stack ? 1 : 0
  name  = "nats"

  model       = var.model_name
  constraints = join(" ", var.constraints)

  charm {
    name    = "nats"
    channel = "latest/stable"
    base    = local.base
  }

  units     = 1
  placement = juju_machine.streaming_stack.machine_id

  // FIXME: Currently the provider has some issues with reconciling state using
  // the response from the JUJU APIs. This is done just to ignore the changes in
  // string values returned.
  lifecycle {
    ignore_changes = [constraints]
  }
  depends_on = [juju_machine.streaming_stack]
}

resource "juju_application" "gateway" {
  count = var.deploy_streaming_stack ? 1 : 0
  name  = "anbox-stream-gateway"

  model       = var.model_name
  constraints = join(" ", var.constraints)

  charm {
    name    = "anbox-stream-gateway"
    channel = var.channel
    base    = local.base
  }

  units     = 1
  placement = juju_machine.streaming_stack.machine_id

  config = {
    ua_token         = var.ua_token
    use_insecure_tls = !var.deploy_lb
  }

  // FIXME: Currently the provider has some issues with reconciling state using
  // the response from the JUJU APIs. This is done just to ignore the changes in
  // string values returned.
  lifecycle {
    ignore_changes = [constraints]
  }
  depends_on = [juju_machine.streaming_stack]
}

resource "juju_application" "dashboard" {
  count = (var.deploy_streaming_stack && var.deploy_dashboard) ? 1 : 0
  name  = "anbox-cloud-dashboard"

  model       = var.model_name
  constraints = join(" ", var.constraints)

  charm {
    name    = "anbox-cloud-dashboard"
    channel = var.channel
    base    = local.base
  }

  config = {
    ua_token = var.ua_token
  }

  units     = 1
  placement = juju_machine.streaming_stack.machine_id

  // FIXME: Currently the provider has some issues with reconciling state using
  // the response from the JUJU APIs. This is done just to ignore the changes in
  // string values returned.
  lifecycle {
    ignore_changes = [constraints]
  }
  depends_on = [juju_machine.streaming_stack]
}

resource "juju_application" "agent" {
  count = var.deploy_streaming_stack ? 1 : 0
  name  = "anbox-stream-agent"

  model       = var.model_name
  constraints = join(" ", var.constraints)

  charm {
    name    = "anbox-stream-agent"
    channel = var.channel
    base    = local.base
  }

  units     = 1
  placement = juju_machine.control_plane.machine_id

  config = {
    ua_token = var.ua_token
    region   = "cloud-0"
  }

  // FIXME: Currently the provider has some issues with reconciling state using
  // the response from the JUJU APIs. This is done just to ignore the changes in
  // string values returned.
  lifecycle {
    ignore_changes = [constraints]
  }
  depends_on = [juju_machine.control_plane]
}

resource "juju_application" "coturn" {
  count = var.deploy_streaming_stack ? 1 : 0
  name  = "coturn"

  model       = var.model_name
  constraints = join(" ", var.constraints)

  charm {
    name = "coturn"
    base = local.base
    // Since this is released by Anbox Charmer, this charm is release with anbox
    // releases
    channel = var.channel
  }

  units     = 1
  placement = juju_machine.control_plane.machine_id

  // FIXME: Currently the provider has some issues with reconciling state using
  // the response from the JUJU APIs. This is done just to ignore the changes in
  // string values returned.
  lifecycle {
    ignore_changes = [constraints]
  }
  depends_on = [juju_machine.control_plane]
}

resource "juju_application" "ca" {
  count = var.deploy_streaming_stack ? 1 : 0
  name  = "internal-ca"

  model       = var.model_name
  constraints = join(" ", var.constraints)

  charm {
    name    = "easyrsa"
    base    = local.base
    channel = "latest/stable"
  }

  units     = 1
  placement = juju_machine.control_plane.machine_id

  // FIXME: Currently the provider has some issues with reconciling state using
  // the response from the JUJU APIs. This is done just to ignore the changes in
  // string values returned.
  lifecycle {
    ignore_changes = [constraints]
  }
  depends_on = [juju_machine.control_plane]
}

resource "juju_application" "lb" {
  count = var.deploy_streaming_stack && var.deploy_lb ? 1 : 0
  name  = "anbox-stream-gateway-lb"

  model       = var.model_name
  constraints = join(" ", var.constraints)

  charm {
    name     = "haproxy"
    channel  = "latest/stable"
    revision = 66
    // TODO: the HA proxy charm does not work well on 22.04 on ARM, so we pin
    // the revision of the charm as we currently do for our full bundle.
    // base = local.base
  }
  config = {
    default_mode = "tcp"
    peering_mode = "active-active"
    ssl_cert     = "SELFSIGNED"
    ssl_key      = "SELFSIGNED"
    services     = file("${path.module}/configs/haproxy.yaml")
  }

  units = 1
  // FIXME: Currently the provider has some issues with reconciling state using
  // the response from the JUJU APIs. This is done just to ignore the changes in
  // string values returned.
  lifecycle {
    ignore_changes = [constraints]
  }
}
resource "juju_integration" "ams_agent" {
  count = var.deploy_streaming_stack ? 1 : 0
  model = var.model_name

  application {
    name     = one(juju_application.agent[*].name)
    endpoint = "ams"
  }

  application {
    name     = one(juju_application.ams[*].name)
    endpoint = "rest-api"
  }
}

resource "juju_integration" "agent_nats" {
  count = var.deploy_streaming_stack ? 1 : 0
  model = var.model_name

  application {
    name     = one(juju_application.agent[*].name)
    endpoint = "nats"
  }

  application {
    name     = one(juju_application.nats[*].name)
    endpoint = "client"
  }
}

resource "juju_integration" "gateway_nats" {
  count = var.deploy_streaming_stack ? 1 : 0
  model = var.model_name

  application {
    name     = one(juju_application.gateway[*].name)
    endpoint = "nats"
  }

  application {
    name     = one(juju_application.nats[*].name)
    endpoint = "client"
  }
}

resource "juju_integration" "nats_ca" {
  count = var.deploy_streaming_stack ? 1 : 0
  model = var.model_name

  application {
    name     = one(juju_application.ca[*].name)
    endpoint = "client"
  }

  application {
    name     = one(juju_application.nats[*].name)
    endpoint = "ca-client"
  }
}

resource "juju_integration" "agent_ca" {
  count = var.deploy_streaming_stack ? 1 : 0
  model = var.model_name

  application {
    name     = one(juju_application.ca[*].name)
    endpoint = "client"
  }

  application {
    name     = one(juju_application.agent[*].name)
    endpoint = "certificates"
  }
}

resource "juju_integration" "gateway_ca" {
  count = var.deploy_streaming_stack ? 1 : 0
  model = var.model_name

  application {
    name     = one(juju_application.ca[*].name)
    endpoint = "client"
  }

  application {
    name     = one(juju_application.gateway[*].name)
    endpoint = "certificates"
  }
}

resource "juju_integration" "coturn_agent" {
  count = var.deploy_streaming_stack ? 1 : 0
  model = var.model_name

  application {
    name     = one(juju_application.coturn[*].name)
    endpoint = "stun"
  }

  application {
    name     = one(juju_application.agent[*].name)
    endpoint = "stun"
  }
}

resource "juju_integration" "dashboard_ca" {
  count = var.deploy_dashboard && var.deploy_streaming_stack ? 1 : 0
  model = var.model_name

  application {
    name     = one(juju_application.ca[*].name)
    endpoint = "client"
  }

  application {
    name     = one(juju_application.dashboard[*].name)
    endpoint = "certificates"
  }
}

resource "juju_integration" "dashboard_gateway" {
  count = var.deploy_dashboard && var.deploy_streaming_stack ? 1 : 0
  model = var.model_name

  application {
    name     = juju_application.ams.name
    endpoint = "rest-api"
  }

  application {
    name     = one(juju_application.dashboard[*].name)
    endpoint = "ams"
  }
}

resource "juju_integration" "lb_gateway" {
  count = var.deploy_streaming_stack && var.deploy_lb ? 1 : 0
  model = var.model_name

  application {
    name     = one(juju_application.gateway[*].name)
    endpoint = "api"
  }

  application {
    name     = one(juju_application.lb[*].name)
    endpoint = "reverseproxy"
  }
}

resource "juju_integration" "lb_dashboard" {
  count = var.deploy_streaming_stack && var.deploy_dashboard && var.deploy_lb ? 1 : 0
  model = var.model_name

  application {
    name     = one(juju_application.dashboard[*].name)
    endpoint = "reverseproxy"
  }

  application {
    name     = one(juju_application.lb[*].name)
    endpoint = "reverseproxy"
  }
}


resource "juju_machine" "streaming_stack" {
  model       = var.model_name
  base        = local.base
  constraints = join(" ", var.constraints)
  // FIXME: Currently the provider has some issues with reconciling state using
  // the response from the JUJU APIs. This is done just to ignore the changes in
  // string values returned.
  lifecycle {
    ignore_changes = [constraints]
  }
}
