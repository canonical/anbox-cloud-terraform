//
// Copyright 2025 Canonical Ltd.  All rights reserved.
//

locals {
  subcluster_config_map = { for obj in var.subclusters : obj.name => {
    node_count      = obj.lxd_node_count
    registry_config = var.deploy_registry && obj.registry != null ? { mode = obj.registry.mode, offer_url = obj.registry.mode == "client" ? one(module.registry[*].client_offer_url) : one(module.registry[*].publisher_offer_url) } : null
  } }
}

module "subcluster" {
  for_each         = local.subcluster_config_map
  source           = "./modules/subcluster"
  model_suffix     = each.key
  ubuntu_pro_token = var.ubuntu_pro_token
  channel          = var.anbox_channel
  external_etcd    = true
  constraints      = var.constraints
  enable_ha        = var.enable_ha
  registry_config  = each.value.registry_config

  // We let the `lxd_node_count` value override the HA configuration for number
  // of LXD nodes.
  lxd_nodes = var.enable_ha ? (each.value.node_count >= 3 ? each.value.node_count : 3) : each.value.node_count
}

module "controller" {
  source           = "./modules/controller"
  ubuntu_pro_token = var.ubuntu_pro_token
  channel          = var.anbox_channel
  constraints      = var.constraints
  enable_ha        = var.enable_ha
}

module "registry" {
  count            = var.deploy_registry ? 1 : 0
  source           = "./modules/registry"
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
