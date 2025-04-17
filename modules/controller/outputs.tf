output "nats_offer_url" {
  value = juju_offer.nats_offer.url
}

output "model_name" {
  value = juju_model.controller.name
}

output "dashboard_app_name" {
  value = juju_application.dashboard.name
}
