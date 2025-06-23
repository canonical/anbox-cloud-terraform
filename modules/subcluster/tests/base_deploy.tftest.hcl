//
// Copyright 2025 Canonical Ltd.  All rights reserved.
//

run "test_model_name" {
  command = plan
  variables {
    model_suffix = "a"
  }
  assert {
    condition     = juju_model.subcluster.name == "anbox-subcluster-a"
    error_message = "Model name for subcluster should be of the format `anbox-subcluster-<model_suffix>`"
  }
}

run "test_default_lxd_nodes" {
  command = plan
  variables {
    model_suffix = "-a"
  }
  assert {
    condition     = juju_application.lxd.units > 0
    error_message = "Default number of lxd nodes should be 1"
  }
}

run "test_lxd_nodes_scale" {
  command = plan
  variables {
    model_suffix = "-a"
    lxd_nodes    = 3
  }
  assert {
    condition     = juju_application.lxd.units == 3
    error_message = "Number of lxd applications should be 3"
  }
  assert {
    condition     = length(juju_machine.lxd_node) == 3
    error_message = "Number of lxd machines should be 3"
  }
}

run "test_external_etcd_disabled" {
  command = plan
  variables {
    model_suffix = "-a"
  }
  assert {
    condition     = length(juju_machine.db_node) == 0
    error_message = "ETCD should not be deployed by default"
  }
  assert {
    condition     = length(juju_application.etcd) == 0
    error_message = "ETCD should not be deployed by default"
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

run "test_base_deployment_layout" {
  command = plan
  variables {
    model_suffix   = "-a"
    ssh_public_key = "ssh-rsa test-key a@b"
  }
  assert {
    condition     = length(juju_machine.ams_node) == 1
    error_message = "A separate machine should be created for AMS."
  }
  assert {
    condition     = length(juju_ssh_key.this) > 0
    error_message = "SSH Key not imported in the model."
  }
  assert {
    condition     = length(juju_machine.lxd_node) == 1
    error_message = "A separate machine should be created for lxd."
  }
  assert {
    condition     = length(juju_machine.db_node) == 0
    error_message = "ETCD should not be deployed by default."
  }
  assert {
    condition     = length(juju_model.subcluster) > 0
    error_message = "A separate model should be created for subcluster."
  }
  assert {
    condition     = length(juju_application.ams) > 0
    error_message = "AMS should be deployed by default."
  }
  assert {
    condition     = length(juju_application.agent) > 0
    error_message = "Anbox Stream Agent should be deployed by default."
  }
  assert {
    condition     = length(juju_application.ca) > 0
    error_message = "CA should be deployed by default."
  }
  assert {
    condition     = length(juju_application.coturn) > 0
    error_message = "Coturn should not be deployed by default."
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
    error_message = "Agent should be related to CA."
  }
  assert {
    condition     = length(juju_integration.coturn_agent) > 0
    error_message = "Coturn should be related to Agent."
  }
  assert {
    condition     = length(juju_integration.ams_lxd) > 0
    error_message = "AMS should be related to LXD."
  }
  assert {
    condition     = length(juju_integration.ip_table_rules) > 0
    error_message = "LXD should be related to AMS Node Controller."
  }
  assert {
    condition     = juju_application.lxd.units == 1
    error_message = "Default number of lxd nodes should be 1."
  }
  assert {
    condition     = length(juju_application.ams_node_controller) > 0
    error_message = "AMS Node Controller should be deployed by default."
  }
  assert {
    condition     = length(juju_integration.ams_aar) == 0
    error_message = "Registry relation should not be configured."
  }
}

run "test_registry" {
  command = plan
  variables {
    model_suffix    = "a"
    registry_config = { mode = "client", offer_url = "client_url" }
  }
  assert {
    condition     = length(juju_integration.ams_aar) > 0
    error_message = "Registry relation should be configured."
  }
}
