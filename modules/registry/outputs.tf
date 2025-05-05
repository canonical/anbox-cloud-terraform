#
# Copyright 2025 Canonical Ltd.  All rights reserved.
#

output "client_offer_url" {
  value       = juju_offer.client_offer.url
  description = "Juju Offer URL for connecting to AAR in `client` mode."
}

output "publisher_offer_url" {
  value       = juju_offer.publisher_offer.url
  description = "Juju Offer URL for connecting to AAR in `publisher` mode."
}

output "model_name" {
  value       = juju_model.registry.name
  description = "Model name created for Anbox Application Registry"
}
