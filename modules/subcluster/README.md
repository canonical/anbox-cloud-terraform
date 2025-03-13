<!-- BEGIN_TF_DOCS -->
# Anbox Cloud Terraform

This is a terraform module to deploy anbox cloud bundle using juju and terraform.
The module uses `terraform-provider-juju` to deploy the anbox charm to a
juju model.

This module uses a `model_name` and `region` to deploy an anbox subcluster.

### Some features of the deployment

* The module deploys a control plane on 1 juju machine. The control plane currently
includes:
- AMS
- ETCD (optional)
- EasyRSA (optional)

* This module can deploy a number of LXD machines to act as nodes to AMS using the
input variable `var.lxd_nodes`.
* Each LXD node is accompanied by a subordinate charm `ams-node-controller` to
setup network rules properly on the lxd node.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.6 |
| <a name="requirement_juju"></a> [juju](#requirement\_juju) | ~> 0.17.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_juju"></a> [juju](#provider\_juju) | ~> 0.17.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [juju_application.agent](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.ams](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.ams_node_controller](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.ca](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.coturn](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.dashboard](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.etcd](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.etcd_ca](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.gateway](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.lb](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.lxd](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.nats](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_integration.agent_ca](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.agent_nats](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.ams_agent](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.ams_db](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.ams_node](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.coturn_agent](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.dashboard_ca](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.dashboard_gateway](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.etcd_ca](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.gateway_ca](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.gateway_nats](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.ip_table_rules](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.lb_dashboard](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.lb_gateway](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.nats_ca](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_channel"></a> [channel](#input\_channel) | Channel for the deployed charm | `string` | `"latest/stable"` | no |
| <a name="input_constraints"></a> [constraints](#input\_constraints) | List of constraints that need to be applied to applications. Each constraint must be of format `<constraint_name>=<constraint_value>` | `list(string)` | `[]` | no |
| <a name="input_deploy_dashboard"></a> [deploy\_dashboard](#input\_deploy\_dashboard) | Deploy anbox cloud dashboard with the streaming stack | `bool` | `false` | no |
| <a name="input_deploy_lb"></a> [deploy\_lb](#input\_deploy\_lb) | Deploy a load balancer with anbox cloud streaming stack | `bool` | `false` | no |
| <a name="input_deploy_streaming_stack"></a> [deploy\_streaming\_stack](#input\_deploy\_streaming\_stack) | Deploy anbox cloud streaming stack | `bool` | `false` | no |
| <a name="input_external_etcd"></a> [external\_etcd](#input\_external\_etcd) | Channel for the deployed charm | `bool` | `false` | no |
| <a name="input_lxd_nodes"></a> [lxd\_nodes](#input\_lxd\_nodes) | Channel for the deployed charm | `number` | `1` | no |
| <a name="input_model_name"></a> [model\_name](#input\_model\_name) | Model name used to deploy the applications | `string` | n/a | yes |
| <a name="input_ubuntu_pro_token"></a> [ubuntu\_pro\_token](#input\_ubuntu\_pro\_token) | Pro token used to deploy AMS charm | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_applications"></a> [applications](#output\_applications) | List of applications deployed |
<!-- END_TF_DOCS -->