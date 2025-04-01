//
// Copyright 2025 Canonical Ltd.  All rights reserved.
//

run "test_required_variables" {
  command = plan
  variables {
    ubuntu_pro_token       = ""
    anbox_channel          = ""
    cloud_name             = ""
    subclusters_per_region = {}
  }
  expect_failures = [var.ubuntu_pro_token, var.anbox_channel, var.cloud_name, var.subclusters_per_region]
}

run "test_models_per_subcluster" {
  command = plan
  variables {
    ubuntu_pro_token       = "token"
    anbox_channel          = "1.26/edge"
    cloud_name             = "lxd"
    subclusters_per_region = { "region-1" = ["a", "b"], "region-2" = ["x"] }
  }

  assert {
    condition     = length(juju_model.anbox_cloud) == 3
    error_message = "A model should be created per label per region."
  }

  assert {
    condition = alltrue([
      for name, obj in juju_model.anbox_cloud : obj.config == tomap({
        logging-config              = "<root>=INFO"
        update-status-hook-interval = "5m"
      })
    ])
    error_message = "Every model should have the defined model config."
  }

  assert {
    condition     = length(module.subcluster) == length(juju_model.anbox_cloud)
    error_message = "Every subcluster should be in 1 model."
  }
}
