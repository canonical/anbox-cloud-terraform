//
// Copyright 2025 Canonical Ltd.  All rights reserved.
//

run "test_only_streaming_stack_enabled" {
  command = plan
  variables {
    ubuntu_pro_token       = "token"
    model_name             = "test-model"
    deploy_streaming_stack = true
  }
  assert {
    condition     = length(juju_application.nats) == 1
    error_message = "NATS not deployed in streaming stack."
  }
  assert {
    condition     = length(juju_application.gateway) == 1
    error_message = "Gateway not deployed in streaming stack."
  }
  assert {
    condition     = length(juju_application.agent) == 1
    error_message = "Anbox Stream Agent not deployed in streaming stack."
  }
  assert {
    condition     = length(juju_application.dashboard) == 0
    error_message = "Anbox Cloud Dashboard should not be deployed when only streaming stack is needed."
  }
  assert {
    condition     = length(juju_application.ca) == 1
    error_message = "CA not deployed."
  }
  assert {
    condition     = length(juju_application.lb) == 0
    error_message = "Load balancer should not be deployed by default."
  }
  assert {
    condition     = length(juju_application.coturn) == 1
    error_message = "Coturn not be deployed."
  }
  assert {
    condition     = length(juju_integration.agent_ams) == 1
    error_message = "AMS not relate to agent."
  }
  assert {
    condition     = length(juju_integration.ams_agent_streaming) == 1
    error_message = "AMS not relate to agent to share api token."
  }
  assert {
    condition     = length(juju_integration.agent_nats) == 1
    error_message = "Agent not related to NATS"
  }
  assert {
    condition     = length(juju_integration.gateway_nats) == 1
    error_message = "Gateway not related to NATS"
  }
  assert {
    condition     = length(juju_integration.gateway_ca) == 1
    error_message = "Gateway not related to CA"
  }
  assert {
    condition     = length(juju_integration.agent_ca) == 1
    error_message = "Agent not related to CA"
  }
  assert {
    condition     = length(juju_integration.dashboard_ca) == 0
    error_message = "Dashboard shoult not be related to CA"
  }
  assert {
    condition     = length(juju_integration.nats_ca) == 1
    error_message = "NATS not related to CA"
  }
  assert {
    condition     = length(juju_integration.coturn_agent) == 1
    error_message = "Coturn not related to Agent"
  }
  assert {
    condition     = length(juju_integration.dashboard_gateway) == 0
    error_message = "Dashboard should not be related to Gateway"
  }
  assert {
    condition     = length(juju_integration.lb_dashboard) == 0
    error_message = "Dashboard should not be related to Load Balancer"
  }
  assert {
    condition     = length(juju_integration.lb_gateway) == 0
    error_message = "Gateway should not be related to Load Balancer"
  }
}
