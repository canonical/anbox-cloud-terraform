//
// Copyright 2025 Canonical Ltd.  All rights reserved.
//

run "test_required_variables" {
  command = plan
  variables {
    ubuntu_pro_token  = ""
    anbox_channel     = ""
    subcluster_labels = []
  }
  expect_failures = [var.ubuntu_pro_token, var.anbox_channel, var.subcluster_labels]
}

run "test_models_per_subcluster" {
  command = plan
  variables {
    ubuntu_pro_token  = "token"
    anbox_channel     = "1.26/edge"
    subcluster_labels = ["a", "b", "c"]
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
