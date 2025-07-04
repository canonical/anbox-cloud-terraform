//
// Copyright 2025 Canonical Ltd.  All rights reserved.
//

variables {
  channel        = "1.26/stable"
  constraints    = [""]
  ssh_public_key = "ssh-rsa test-key a@b"
}

run "test_base_controller_resources" {
  command = plan
  assert {
    condition     = length(juju_model.controller) > 0
    error_message = "Model not created in controller."
  }
  assert {
    condition     = length(juju_ssh_key.this) > 0
    error_message = "SSH Key not imported in the model."
  }
  assert {
    condition     = length(juju_machine.controller_node) == 1
    error_message = "NATS not deployed in controller."
  }
  assert {
    condition     = length(juju_application.nats) > 0
    error_message = "NATS not deployed in controller."
  }
  assert {
    condition     = length(juju_application.gateway) > 0
    error_message = "Gateway not deployed in controller."
  }
  assert {
    condition     = length(juju_application.dashboard) > 0
    error_message = "Anbox Cloud Dashboard not deployed in controller."
  }
  assert {
    condition     = length(juju_application.ca) > 0
    error_message = "CA not deployed in controller."
  }
  assert {
    condition     = length(juju_integration.gateway_nats) > 0
    error_message = "Gateway not related to NATS."
  }
  assert {
    condition     = length(juju_integration.gateway_ca) > 0
    error_message = "Gateway not related to CA."
  }
  assert {
    condition     = length(juju_integration.dashboard_ca) > 0
    error_message = "Dashboard not related to CA."
  }
  assert {
    condition     = length(juju_integration.nats_ca) > 0
    error_message = "NATS not related to CA."
  }
  assert {
    condition     = length(juju_integration.dashboard_gateway) > 0
    error_message = "Dashboard not related to Gateway."
  }
}

run "test_ha_deployment" {
  command = plan
  variables {
    enable_ha = true
  }
  assert {
    condition     = length(juju_machine.controller_node) == 3
    error_message = "NATS not deployed in controller."
  }
  assert {
    condition     = length(juju_model.controller) > 0
    error_message = "Model not created in controller."
  }
  assert {
    condition     = length(juju_application.nats) > 0
    error_message = "NATS not deployed in controller."
  }
  assert {
    condition     = juju_application.nats.units == 3
    error_message = "HA for NATS must deploy 3 units"
  }
  assert {
    condition     = length(juju_application.gateway) > 0
    error_message = "Gateway not deployed in controller."
  }
  assert {
    condition     = juju_application.gateway.units == 3
    error_message = "HA for gateway must deploy 3 units"
  }
  assert {
    condition     = length(juju_application.dashboard) > 0
    error_message = "Anbox Cloud Dashboard not deployed in controller."
  }
  assert {
    condition     = juju_application.dashboard.units == 3
    error_message = "HA for dashboard must deploy 3 units"
  }
  assert {
    condition     = length(juju_application.ca) > 0
    error_message = "CA not deployed in controller."
  }
  assert {
    condition     = juju_application.ca.units == 3
    error_message = "HA for CA must deploy 3 units"
  }
  assert {
    condition     = length(juju_integration.gateway_nats) > 0
    error_message = "Gateway not related to NATS."
  }
  assert {
    condition     = length(juju_integration.gateway_ca) > 0
    error_message = "Gateway not related to CA."
  }
  assert {
    condition     = length(juju_integration.dashboard_ca) > 0
    error_message = "Dashboard not related to CA."
  }
  assert {
    condition     = length(juju_integration.nats_ca) > 0
    error_message = "NATS not related to CA."
  }
  assert {
    condition     = length(juju_integration.dashboard_gateway) > 0
    error_message = "Dashboard not related to Gateway."
  }
}

