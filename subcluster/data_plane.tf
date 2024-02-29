resource "juju_application" "lxd" {
  name = "lxd"

  model     = juju_model.anbox_cloud.name
  constraints = join(" ", var.constraints, ["mem=1024M", "root-disk=10240M", "root-disk-source=local"])

  charm {
    name    = "ams-lxd"
    channel = var.channel
  }

  config = {
    ua_token = var.ua_token
  }

  units = var.lxd_nodes
  // FIXME: Currently the provider has some issues with reconciling state using
  // the response from the JUJU APIs. This is done just to ignore the changes in
  // string values returned.
  lifecycle {
    ignore_changes = [ constraints ]
  }
}

resource "juju_application" "ams_node_controller" {
  name = "ams-node-controller"

  model = juju_model.anbox_cloud.name

  charm {
    name    = "ams-node-controller"
    channel = var.channel
  }

  // The provider currently does not know properly about subordinate charms
  // So we specify 0 units as this will get attached automatically to the
  // principal charm after relation.
  units = 0

  config = {
    port = "10000-11000"
  }
}

resource "juju_integration" "ip_table_rules" {
  model = juju_model.anbox_cloud.name

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
  model = juju_model.anbox_cloud.name

  application {
    name     = juju_application.ams.name
    endpoint = "lxd"
  }

  application {
    name     = juju_application.lxd.name
    endpoint = "api"
  }
}
