#
# Copyright 2025 Canonical Ltd.  All rights reserved.
#
output "ams_offer_url" {
  value = juju_offer.ams_offer.url
}

output "model_name" {
  value = juju_model.subcluster.name
}

output "agent_app_name" {
  value = juju_application.agent.name
}
