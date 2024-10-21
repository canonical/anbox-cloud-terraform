resource "juju_application" "ams" {
  name = "ams"

  model       = var.model_name
  constraints = join(" ", var.constraints)

  charm {
    name    = "ams"
    channel = var.channel
    base    = local.base
  }

  units     = 1
  placement = juju_machine.control_plane.machine_id

  config = {
    ua_token          = var.ua_token
    use_embedded_etcd = !var.external_etcd
  }

  // FIXME: Currently the provider has some issues with reconciling state using
  // the response from the JUJU APIs. This is done just to ignore the changes in
  // string values returned.
  lifecycle {
    ignore_changes = [constraints]
  }

  depends_on = [juju_machine.control_plane]
}

resource "juju_application" "etcd" {
  count = var.external_etcd ? 1 : 0
  name  = "etcd"

  model       = var.model_name
  constraints = join(" ", var.constraints)
  placement   = juju_machine.control_plane.machine_id

  charm {
    name    = "etcd"
    channel = "latest/stable"
    base    = local.base
  }

  config = {
    channel = "3.4/stable"
  }

  units = 1
  // FIXME: Currently the provider has some issues with reconciling state using
  // the response from the JUJU APIs. This is done just to ignore the changes in
  // string values returned.
  lifecycle {
    ignore_changes = [constraints]
  }
  depends_on = [juju_machine.control_plane]
}

resource "juju_application" "etcd_ca" {
  count = var.external_etcd ? 1 : 0
  name  = "etcd-ca"

  model       = var.model_name
  constraints = join(" ", var.constraints)
  placement   = juju_machine.control_plane.machine_id

  charm {
    name    = "easyrsa"
    channel = "latest/stable"
    base    = local.base
  }

  units      = 1
  depends_on = [juju_machine.control_plane]
}

resource "juju_integration" "ams_db" {
  count = var.external_etcd ? 1 : 0
  model = var.model_name

  application {
    name     = juju_application.ams.name
    endpoint = "etcd"
  }

  application {
    name     = one(juju_application.etcd[*].name)
    endpoint = "db"
  }
}

resource "juju_integration" "etcd_ca" {
  count = var.external_etcd ? 1 : 0
  model = var.model_name

  application {
    name     = one(juju_application.etcd_ca[*].name)
    endpoint = "client"
  }

  application {
    name     = one(juju_application.etcd[*].name)
    endpoint = "certificates"
  }
}

resource "juju_machine" "control_plane" {
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
