//
// Copyright 2025 Canonical Ltd.  All rights reserved.
//

variables {
  ubuntu_pro_token = "token"
  channel          = "1.26/stable"
  constraints      = [""]
}

run "test_base_controller_resources" {
  command = plan
  assert {
    condition     = length(juju_model.registry) > 0
    error_message = "Model not created in controller."
  }
  assert {
    condition     = length(juju_application.aar) > 0
    error_message = "AAR should be deployed."
  }
}

run "test_ha_deployment" {
  command = plan
  variables {
    enable_ha = true
  }
  assert {
    condition     = length(juju_model.registry) > 0
    error_message = "Model not created in controller."
  }
  assert {
    condition     = length(juju_application.aar) > 0
    error_message = "AAR should be deployed."
  }
  assert {
    condition     = juju_application.aar.units == 3
    error_message = "AAR should be have 3 units in HA mode."
  }
}

