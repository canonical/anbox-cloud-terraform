//
// Copyright 2025 Canonical Ltd.  All rights reserved.
//

run "test_external_etcd_enabled" {
  command = plan
  variables {
    ubuntu_pro_token = "token"
    model_suffix     = "test-model"
    external_etcd    = true
  }
  assert {
    condition     = length(juju_application.etcd) == 1
    error_message = "ETCD not deployed."
  }
  assert {
    condition     = length(juju_integration.ams_db) == 1
    error_message = "AMS not relate to ETCD"
  }
  assert {
    condition     = length(juju_integration.etcd_ca) == 1
    error_message = "ETCD not related to CA."
  }
  assert {
    condition     = juju_application.etcd[0].charm[0].name == "etcd"
    error_message = "etcd charm should be used to deploy ETCD"
  }
  assert {
    condition     = juju_application.etcd[0].config == tomap({ channel = "3.4/stable" })
    error_message = "etcd charm should be used to deploy ETCD"
  }
}
