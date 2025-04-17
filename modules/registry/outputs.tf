#
# Copyright 2025 Canonical Ltd.  All rights reserved.
#
output "client_offer_url" {
  value = juju_offer.client_offer.url
}

output "publisher_offer_url" {
  value = juju_offer.publisher_offer.url
}
