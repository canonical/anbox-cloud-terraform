resource "juju_application" "lxd" {
  name = "lxd"

  model       = var.model_name
  constraints = join(" ", concat(var.constraints, ["root-disk=10240M"]))

  charm {
    name    = "ams-lxd"
    channel = var.channel
    base    = local.base
  }

  config = {
    ua_token = var.ua_token
  }

  units = var.lxd_nodes
  // FIXME: Currently the provider has some issues with reconciling state using
  // the response from the JUJU APIs. This is done just to ignore the changes in
  // string values returned.
  lifecycle {
    ignore_changes = [constraints]
  }
}

resource "juju_application" "ams_node_controller" {
  name = "ams-node-controller"

  model = var.model_name

  charm {
    name    = "ams-node-controller"
    channel = var.channel
  }

  // The provider currently does not know properly about subordinate charms
  // So we specify 0 units as this will get attached automatically to the
  // principal charm after relation.
  units = 0

  config = {
    port            = "10000-11000"
    ua_token        = var.ua_token
    snap_risk_level = local.risk
  }
}

resource "juju_integration" "ip_table_rules" {
  model = var.model_name

  application {
    name     = juju_application.ams_node_controller.name
    endpoint = "lxd"
  }

  application {
    name     = juju_application.lxd.name
    endpoint = "api"
  }
}

resource "juju_integration" "ams_node" {
  model = var.model_name

  application {
    name     = juju_application.ams.name
    endpoint = "lxd"
  }

  application {
    name     = juju_application.lxd.name
    endpoint = "api"
  }
}
