//
// Copyright 2025 Canonical Ltd.  All rights reserved.
//

resource "juju_application" "lxd" {
  name = "lxd"

  model_uuid  = juju_model.subcluster.uuid
  constraints = join(" ", concat(var.constraints, ["root-disk=10240M"]))

  charm {
    name    = "ams-lxd"
    channel = var.channel
    base    = local.base
  }

  config = {
    ua_token                        = var.ubuntu_pro_token
    node_controller_snap_risk_level = local.risk
  }

  machines = juju_machine.lxd_node[*].machine_id
  // FIXME: Currently the provider has some issues with reconciling state using
  // the response from the JUJU APIs. This is done just to ignore the changes in
  // string values returned.
  lifecycle {
    ignore_changes = [constraints]
  }
}

resource "juju_integration" "ams_lxd" {
  model_uuid = juju_model.subcluster.uuid

  application {
    name     = juju_application.ams.name
    endpoint = "lxd"
  }

  application {
    name     = juju_application.lxd.name
    endpoint = "api"
  }
}

resource "juju_machine" "lxd_node" {
  model_uuid  = juju_model.subcluster.uuid
  count       = var.lxd_nodes
  base        = local.base
  name        = "lxd-${count.index}"
  constraints = join(" ", var.constraints)
}
