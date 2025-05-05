//
// Copyright 2025 Canonical Ltd.  All rights reserved.
//

locals {
  // we need to remove all special characters from the string to use it as
  // an identifier for an offer.
  offer_suffix = replace(var.model_suffix, "/[-_.]*/", "")
  num_units    = var.enable_ha ? 3 : 1
}

resource "juju_model" "subcluster" {
  name = "anbox-subcluster-${var.model_suffix}"

  constraints = join(" ", var.constraints)

  config = {
    logging-config              = "<root>=INFO"
    update-status-hook-interval = "5m"
  }
}

resource "juju_application" "ams" {
  name = "ams"

  model       = juju_model.subcluster.name
  constraints = join(" ", var.constraints)
  machines    = juju_machine.ams_node[*].machine_id

  charm {
    name    = "ams"
    channel = var.channel
    base    = local.base
  }

  config = {
    ua_token          = var.ubuntu_pro_token
    use_embedded_etcd = !var.external_etcd
    snap_risk_level   = local.risk
  }

  // FIXME: Currently the provider has some issues with reconciling state using
  // the response from the JUJU APIs. This is done just to ignore the changes in
  // string values returned.
  lifecycle {
    ignore_changes = [constraints]
  }
}

resource "juju_application" "etcd" {
  count = var.external_etcd ? 1 : 0
  name  = "etcd"

  model       = juju_model.subcluster.name
  constraints = join(" ", var.constraints)

  charm {
    name    = "etcd"
    channel = "latest/stable"
    base    = local.base
  }

  config = {
    channel = "3.4/stable"
  }

  machines = juju_machine.db_node[*].machine_id
  // FIXME: Currently the provider has some issues with reconciling state using
  // the response from the JUJU APIs. This is done just to ignore the changes in
  // string values returned.
  lifecycle {
    ignore_changes = [constraints]
  }
}

resource "juju_application" "ca" {
  name = "ca"

  model       = juju_model.subcluster.name
  constraints = join(" ", var.constraints)

  charm {
    name    = "self-signed-certificates"
    channel = "latest/stable"
    base    = local.base
  }

  machines = juju_machine.ams_node[*].machine_id
}

resource "juju_application" "etcd_ca" {
  count = var.external_etcd ? 1 : 0
  name  = "etcd-ca"

  model       = juju_model.subcluster.name
  constraints = join(" ", var.constraints)

  charm {
    name    = "easyrsa"
    channel = "latest/stable"
    base    = local.base
  }

  machines = juju_machine.db_node[*].machine_id
}

resource "juju_integration" "ams_db" {
  count = var.external_etcd ? 1 : 0
  model = juju_model.subcluster.name

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
  model = juju_model.subcluster.name

  application {
    name     = one(juju_application.etcd_ca[*].name)
    endpoint = "client"
  }

  application {
    name     = one(juju_application.etcd[*].name)
    endpoint = "certificates"
  }
}

resource "juju_application" "agent" {
  name = "anbox-stream-agent"

  model       = juju_model.subcluster.name
  constraints = join(" ", var.constraints)

  charm {
    name    = "anbox-stream-agent"
    channel = var.channel
    base    = local.base
  }

  machines = juju_machine.ams_node[*].machine_id

  config = {
    ua_token        = var.ubuntu_pro_token
    region          = "cloud-0"
    snap_risk_level = local.risk
  }

  // FIXME: Currently the provider has some issues with reconciling state using
  // the response from the JUJU APIs. This is done just to ignore the changes in
  // string values returned.
  lifecycle {
    ignore_changes = [constraints]
  }
}

resource "juju_application" "coturn" {
  name = "coturn"

  model       = juju_model.subcluster.name
  constraints = join(" ", var.constraints)

  charm {
    name = "coturn"
    base = local.base
    // Since this is released by Anbox Charmer, this charm is release with anbox
    // releases
    channel = var.channel
  }

  machines = juju_machine.ams_node[*].machine_id

  // FIXME: Currently the provider has some issues with reconciling state using
  // the response from the JUJU APIs. This is done just to ignore the changes in
  // string values returned.
  lifecycle {
    ignore_changes = [constraints]
  }
}

resource "juju_integration" "agent_ams" {
  model = juju_model.subcluster.name

  application {
    name     = juju_application.agent.name
    endpoint = "ams"
  }

  application {
    name     = juju_application.ams.name
    endpoint = "rest-api"
  }
}

resource "juju_integration" "ams_agent_streaming" {
  model = juju_model.subcluster.name

  application {
    name     = juju_application.agent.name
    endpoint = "client"
  }

  application {
    name     = juju_application.ams.name
    endpoint = "agent"
  }
}


resource "juju_integration" "agent_ca" {
  model = juju_model.subcluster.name

  application {
    name     = juju_application.ca.name
    endpoint = "client"
  }

  application {
    name     = juju_application.agent.name
    endpoint = "certificates"
  }
}

resource "juju_integration" "coturn_agent" {
  model = juju_model.subcluster.name

  application {
    name     = juju_application.coturn.name
    endpoint = "stun"
  }

  application {
    name     = juju_application.agent.name
    endpoint = "stun"
  }
}

resource "juju_integration" "ams_aar" {
  count = var.registry_config != null ? 1 : 0
  model = juju_model.subcluster.name

  application {
    name     = juju_application.ams.name
    endpoint = "registry-${var.registry_config.mode}"
  }

  application {
    offer_url = var.registry_config.offer_url
  }
}

resource "juju_offer" "ams_offer" {
  model            = juju_model.subcluster.name
  application_name = juju_application.ams.name
  endpoint         = "rest-api"
  name             = "ams${local.offer_suffix}"
}


resource "juju_application" "cos_agent" {
  count = var.enable_cos ? 1 : 0
  name  = "grafana-agent"

  model = juju_model.subcluster.name

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

resource "juju_integration" "ams_cos" {
  count = var.enable_cos ? 1 : 0
  model = juju_model.subcluster.name

  application {
    name     = juju_application.ams.name
    endpoint = "cos-agent"
  }

  application {
    name     = one(juju_application.cos_agent[*].name)
    endpoint = "cos-agent"
  }
}

resource "juju_machine" "ams_node" {
  model       = juju_model.subcluster.name
  count       = local.num_units
  base        = local.base
  name        = "ams-${count.index}"
  constraints = join(" ", var.constraints)
}

resource "juju_machine" "db_node" {
  count       = var.external_etcd ? local.num_units : 0
  model       = juju_model.subcluster.name
  base        = local.base
  name        = "db-${count.index}"
  constraints = join(" ", var.constraints)
}
