//
// Copyright 2025 Canonical Ltd.  All rights reserved.
//

run "test_required_variables" {
  command = plan
  variables {
    ubuntu_pro_token = ""
    model_name       = ""
  }
  expect_failures = [var.ubuntu_pro_token, var.model_name]
}

run "test_default_lxd_nodes" {
  command = plan
  variables {
    ubuntu_pro_token = "token"
    model_name       = "test-model"
  }
  assert {
    condition     = juju_application.lxd.units == 1
    error_message = "Default number of lxd nodes should be 1"
  }
}

run "test_default_external_etcd_disabled" {
  command = plan
  variables {
    ubuntu_pro_token = "token"
    model_name       = "test-model"
  }
  assert {
    condition     = length(juju_application.etcd) == 0
    error_message = "ETCD should not be deployed by default"
  }
  assert {
    condition     = length(juju_application.etcd_ca) == 0
    error_message = "ETCD CA should not be deployed by default"
  }
  assert {
    condition     = length(juju_integration.ams_db) == 0
    error_message = "AMS should not be related to etcd"
  }
  assert {
    condition     = length(juju_integration.etcd_ca) == 0
    error_message = "ETCD should not be related to CA"
  }
}

run "test_default_streaming_stack_dashboard_lb_disabled" {
  command = plan
  variables {
    ubuntu_pro_token = "token"
    model_name       = "test-model"
  }
  assert {
    condition     = length(juju_application.nats) == 0
    error_message = "NATS should not be deployed by default."
  }
  assert {
    condition     = length(juju_application.gateway) == 0
    error_message = "Anbox Stream Gateway should not be deployed by default."
  }
  assert {
    condition     = length(juju_application.agent) == 0
    error_message = "Anbox Stream Agent should not be deployed by default."
  }
  assert {
    condition     = length(juju_application.dashboard) == 0
    error_message = "Anbox Cloud Dashboard should not be deployed by default."
  }
  assert {
    condition     = length(juju_application.ca) == 0
    error_message = "CA should not be deployed by default."
  }
  assert {
    condition     = length(juju_application.lb) == 0
    error_message = "Load balancer should not be deployed by default."
  }
  assert {
    condition     = length(juju_application.coturn) == 0
    error_message = "Coturn should not be deployed by default."
  }
  assert {
    condition     = length(juju_integration.ams_agent) == 0
    error_message = "AMS should not be related to agent."
  }
  assert {
    condition     = length(juju_integration.agent_nats) == 0
    error_message = "Agent should not be related to NATS"
  }
  assert {
    condition     = length(juju_integration.gateway_nats) == 0
    error_message = "Gateway should not be related to NATS"
  }
  assert {
    condition     = length(juju_integration.gateway_ca) == 0
    error_message = "Gateway should not be related to CA"
  }
  assert {
    condition     = length(juju_integration.agent_ca) == 0
    error_message = "Agent should not be related to CA"
  }
  assert {
    condition     = length(juju_integration.dashboard_ca) == 0
    error_message = "Dashboard should not be related to CA"
  }
  assert {
    condition     = length(juju_integration.nats_ca) == 0
    error_message = "NATS should not be related to CA"
  }
  assert {
    condition     = length(juju_integration.coturn_agent) == 0
    error_message = "Coturn should not be related to Agent"
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
