#
# Copyright 2025 Canonical Ltd.  All rights reserved.
#

output "nats_offer_url" {
  value       = juju_offer.nats_offer.url
  description = "Juju offer url for connecting to the NATS charm."
}

output "model_name" {
  value       = juju_model.controller.name
  description = "Model name for the deployed controller."
}

output "model_uuid" {
  value       = juju_model.controller.uuid
  description = "Model uuid for the deployed controller."
}

output "dashboard_app_name" {
  value       = juju_application.dashboard.name
  description = "Anbox Cloud Dashboard application name deployed in the controller model."
}

output "lb_app_name" {
  value       = one(juju_application.lb[*].name)
  description = "Name of the haproxy load balancer application in the controller model. Null if enable_lb is false."
}
