locals {
  model_names = flatten(
    [for region, clusters in var.subclusters_per_region : [for cluster_name in clusters : "${region}.${cluster_name}"]]
  )
}

module "subcluster" {
  for_each               = juju_model.anbox_cloud
  source                 = "./modules/subcluster"
  model_name             = juju_model.anbox_cloud[each.key].name
  ubuntu_pro_token       = var.ubuntu_pro_token
  channel                = var.anbox_channel
  external_etcd          = true
  constraints            = var.constraints
  lxd_nodes              = var.lxd_nodes_per_subcluster
  deploy_streaming_stack = true
  deploy_dashboard       = true
  deploy_lb              = true
}

resource "terraform_data" "juju_wait" {
  for_each = var.wait_for_model ? toset(local.model_names) : []
  triggers_replace = [
    module.subcluster
  ]

  provisioner "local-exec" {
    # Check status of the unit instead of application due to https://github.com/juju/juju/issues/18625
    command = "juju wait-for model ${juju_model.anbox_cloud[each.key].name} --query='life==\"alive\" && status==\"available\" && forEach(units, unit => unit.workload-status == \"active\")'"
  }
}

resource "juju_model" "anbox_cloud" {
  for_each = toset(local.model_names)
  name     = "anbox-cloud-${replace(each.value, ".", "-")}"

  cloud {
    name   = var.cloud_name
    region = split(".", each.value)[0]
  }

  constraints = join(" ", var.constraints)

  config = {
    logging-config              = "<root>=INFO"
    update-status-hook-interval = "5m"
  }
}
