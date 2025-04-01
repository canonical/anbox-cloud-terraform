//
// Copyright 2025 Canonical Ltd.  All rights reserved.
//

run "test_dashboard_deploy_only_when_enabled_with_streaming_stack" {
  command = plan
  variables {
    ubuntu_pro_token       = "token"
    model_name             = "test-model"
    deploy_streaming_stack = false
    deploy_dashboard       = true
  }
  assert {
    condition     = length(juju_application.dashboard) == 0
    error_message = "Anbox Cloud Dashboard should not be deployed when only streaming stack is needed."
  }
  assert {
    condition     = length(juju_integration.dashboard_ca) == 0
    error_message = "Dashboard related to CA"
  }
  assert {
    condition     = length(juju_integration.dashboard_gateway) == 0
    error_message = "Dashboard should not be related to Gateway"
  }
  assert {
    condition     = length(juju_integration.lb_dashboard) == 0
    error_message = "Dashboard should not be related to Load Balancer"
  }
}

run "test_dashboard_with_streaming_stack" {
  command = plan
  variables {
    ubuntu_pro_token       = "token"
    model_name             = "test-model"
    deploy_streaming_stack = true
    deploy_dashboard       = true
  }
  assert {
    condition     = length(juju_application.dashboard) == 1
    error_message = "Anbox Cloud Dashboard should be deployed."
  }
  assert {
    condition     = length(juju_integration.dashboard_ca) == 1
    error_message = "Dashboard should be related to CA."
  }
  assert {
    condition     = length(juju_integration.dashboard_gateway) == 1
    error_message = "Dashboard should be related to Gateway."
  }
  assert {
    condition     = length(juju_integration.lb_dashboard) == 0
    error_message = "Dashboard should not be related to Load Balancer"
  }
}


run "test_dashboard_with_streaming_stack_and_lb" {
  command = plan
  variables {
    ubuntu_pro_token       = "token"
    model_name             = "test-model"
    deploy_streaming_stack = true
    deploy_dashboard       = true
    deploy_lb              = true
  }
  assert {
    condition     = length(juju_application.dashboard) == 1
    error_message = "Anbox Cloud Dashboard should be deployed."
  }
  assert {
    condition     = length(juju_integration.dashboard_ca) == 1
    error_message = "Dashboard should be related to CA."
  }
  assert {
    condition     = length(juju_integration.dashboard_gateway) == 1
    error_message = "Dashboard should be related to Gateway."
  }
  assert {
    condition     = length(juju_integration.lb_dashboard) == 1
    error_message = "Dashboard should not be related to Load Balancer"
  }
  assert {
    condition     = length(juju_application.lb) == 1
    error_message = "Load balancer should be deployed."
  }
  assert {
    condition     = length(juju_integration.lb_gateway) == 1
    error_message = "Gateway should be related to Load Balancer"
  }
  assert {
    condition     = length(juju_integration.lb_dashboard) == 1
    error_message = "Dashboard should be related to Load Balancer"
  }
}
