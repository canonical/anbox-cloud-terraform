//
// Copyright 2025 Canonical Ltd.  All rights reserved.
//

run "test_required_variables" {
  command = plan
  variables {
    ubuntu_pro_token = ""
    anbox_channel    = ""
    subclusters      = []
  }
  expect_failures = [var.ubuntu_pro_token, var.anbox_channel, var.subclusters]
}

run "test_models_per_subcluster" {
  command = plan
  variables {
    ubuntu_pro_token = "token"
    anbox_channel    = "1.26/edge"
    subclusters = [{
      name           = "a"
      lxd_node_count = 1
      }, {
      name           = "b"
      lxd_node_count = 1
      }, {
      name           = "c"
      lxd_node_count = 1
    }]
  }

  assert {
    condition     = length(module.subcluster) == 3
    error_message = "A subcluster should be created per label."
  }

  assert {
    condition     = length(juju_integration.agent_nats_cmr) == 3
    error_message = "Every agent in subcluster should be connected to controller NATS."
  }

  assert {
    condition     = length(juju_integration.dashboard_ams_cmr) == 3
    error_message = "Every AMS in subcluster should be connected to controller Dashboard."
  }
}
