//
// Copyright 2025 Canonical Ltd.  All rights reserved.
//

run "test_registry" {
  command = plan
  variables {
    ubuntu_pro_token = "token"
    anbox_channel    = "1.26/edge"
    subclusters = [{
      name           = "a"
      lxd_node_count = 1
      registry = {
        mode = "client"
      }
    }]
    deploy_registry = true
  }

  assert {
    condition     = length(module.subcluster) == 1
    error_message = "A subcluster should be created per label."
  }

  assert {
    condition     = length(module.registry) == 1
    error_message = "Registry should be deployed"
  }

  assert {
    condition     = local.subcluster_config_map["a"].registry_config.mode == "client"
    error_message = "Registry should be deployed"
  }

  assert {
    condition     = length(juju_integration.agent_nats_cmr) == 1
    error_message = "Every agent in subcluster should be connected to controller NATS."
  }

  assert {
    condition     = length(juju_integration.dashboard_ams_cmr) == 1
    error_message = "Every AMS in subcluster should be connected to controller Dashboard."
  }
}
