//
// Copyright 2025 Canonical Ltd.  All rights reserved.
//

output "applications" {
  value = compact([
    juju_application.ams.id,
    juju_application.lxd.id,
    juju_application.ams_node_controller.id,
    one(juju_application.etcd[*].id),
    one(juju_application.etcd_ca[*].id),
    one(juju_application.gateway[*].id),
    one(juju_application.agent[*].id),
    one(juju_application.dashboard[*].id),
    one(juju_application.nats[*].id),
    one(juju_application.coturn[*].id),
    one(juju_application.ca[*].id),
  ])
  description = "List of applications deployed"
}
