//
// Copyright 2025 Canonical Ltd.  All rights reserved.
//

run "test_ha_deployment" {
  command = plan
  variables {
    model_suffix = "-a"
    enable_ha    = true
  }
  assert {
    condition     = length(juju_model.subcluster) > 0
    error_message = "A separate model should be created for subcluster"
  }
  assert {
    condition     = length(juju_application.ams) > 0
    error_message = "AMS should be deployed by default."
  }
  assert {
    condition     = juju_application.ams.units == 3
    error_message = "HA for AMS must deploy 3 units"
  }
  assert {
    condition     = length(juju_application.agent) > 0
    error_message = "Anbox Stream Agent should be deployed by default."
  }
  assert {
    condition     = juju_application.agent.units == 3
    error_message = "HA for agent must deploy 3 units"
  }
  assert {
    condition     = length(juju_application.ca) > 0
    error_message = "CA should be deployed by default."
  }
  assert {
    condition     = juju_application.ca.units == 3
    error_message = "HA for CA must deploy 3 units"
  }
  assert {
    condition     = length(juju_application.coturn) > 0
    error_message = "Coturn should not be deployed by default."
  }
  assert {
    condition     = juju_application.coturn.units == 3
    error_message = "HA for coturn must deploy 3 units"
  }
  assert {
    condition     = length(juju_integration.ams_agent_streaming) > 0
    error_message = "AMS should be related to agent to share api token."
  }
  assert {
    condition     = length(juju_integration.agent_ams) > 0
    error_message = "AMS should be related to agent."
  }
  assert {
    condition     = length(juju_integration.agent_ca) > 0
    error_message = "Agent should be related to CA"
  }
  assert {
    condition     = length(juju_integration.coturn_agent) > 0
    error_message = "Coturn should be related to Agent"
  }
  assert {
    condition     = length(juju_integration.ams_lxd) > 0
    error_message = "AMS should be related to LXD"
  }
  assert {
    condition     = length(juju_integration.ip_table_rules) > 0
    error_message = "LXD should be related to AMS Node Controller"
  }
  assert {
    condition     = length(juju_application.ams_node_controller) > 0
    error_message = "AMS Node Controller should be deployed by default."
  }
}
