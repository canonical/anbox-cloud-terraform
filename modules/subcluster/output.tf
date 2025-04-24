#
# Copyright 2025 Canonical Ltd.  All rights reserved.
#

output "ams_offer_url" {
  value       = juju_offer.ams_offer.url
  description = "Juju offer url for connecting to the AMS charm."
}

output "model_name" {
  value       = juju_model.subcluster.name
  description = "Model name for the deployed subcluster."
}

output "agent_app_name" {
  value       = juju_application.agent.name
  description = "Anbox Stream Agent application name deployed in the subcluster model."
}
