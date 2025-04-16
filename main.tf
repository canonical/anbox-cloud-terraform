//
// Copyright 2025 Canonical Ltd.  All rights reserved.
//

module "subcluster" {
  for_each         = toset(var.subcluster_labels)
  source           = "./modules/subcluster"
  model_suffix     = each.key
  ubuntu_pro_token = var.ubuntu_pro_token
  channel          = var.anbox_channel
  external_etcd    = true
  constraints      = var.constraints
  enable_ha        = var.enable_ha

  // We let the `lxd_nodes_per_subcluster` value override the HA configuration
  // for number LXD nodes.
  lxd_nodes = var.enable_ha ? (var.lxd_nodes_per_subcluster >= 3 ? var.lxd_nodes_per_subcluster : 3) : var.lxd_nodes_per_subcluster
}

module "controller" {
  source           = "./modules/controller"
  ubuntu_pro_token = var.ubuntu_pro_token
  channel          = var.anbox_channel
  constraints      = var.constraints
  enable_ha        = var.enable_ha
}

resource "juju_integration" "agent_nats_cmr" {
  for_each = module.subcluster
  model    = each.value.model_name

  application {
    name     = each.value.agent_app_name
    endpoint = "nats"
  }

  application {
    offer_url = module.controller.nats_offer_url
  }
}

resource "juju_integration" "dashboard_ams_cmr" {
  for_each = module.subcluster
  model    = module.controller.model_name

  application {
    name     = module.controller.dashboard_app_name
    endpoint = "ams"
  }

  application {
    offer_url = each.value.ams_offer_url
  }
}
