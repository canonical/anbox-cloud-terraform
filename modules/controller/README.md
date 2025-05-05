<!-- BEGIN_TF_DOCS -->
# Anbox Cloud Terraform

This is a terraform module to deploy anbox controller model using juju and terraform.
The module uses `terraform-provider-juju` to deploy the anbox charm to a
juju model.

### Some features of the deployment

* The module deploys a control plane for anbox cloud. The control plane currently
includes:
- NATS
- Anbox Cloud Gateway
- Certificate Authority (CA: Self-signed-certificates)
- Anbox Cloud Dashboard

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.6 |
| <a name="requirement_juju"></a> [juju](#requirement\_juju) | ~> 0.19.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_juju"></a> [juju](#provider\_juju) | 0.18.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [juju_application.ca](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.cos_agent](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.dashboard](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.gateway](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.nats](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_integration.dashboard_ca](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.dashboard_gateway](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.gateway_ca](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.gateway_cos](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.gateway_nats](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.nats_ca](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_machine.controller_node](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/machine) | resource |
| [juju_model.controller](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/model) | resource |
| [juju_offer.nats_offer](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/offer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_channel"></a> [channel](#input\_channel) | Channel for the deployed charm | `string` | `"latest/stable"` | no |
| <a name="input_constraints"></a> [constraints](#input\_constraints) | List of constraints that need to be applied to applications. Each constraint must be of format `<constraint_name>=<constraint_value>` | `list(string)` | `[]` | no |
| <a name="input_enable_cos"></a> [enable\_cos](#input\_enable\_cos) | Enable cos integration by deploying grafana-agent charm. | `bool` | `false` | no |
| <a name="input_enable_ha"></a> [enable\_ha](#input\_enable\_ha) | Number of lxd nodes to deploy per subcluster | `bool` | `false` | no |
| <a name="input_ubuntu_pro_token"></a> [ubuntu\_pro\_token](#input\_ubuntu\_pro\_token) | Pro token used to deploy AMS charm | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dashboard_app_name"></a> [dashboard\_app\_name](#output\_dashboard\_app\_name) | Anbox Cloud Dashboard application name deployed in the controller model. |
| <a name="output_model_name"></a> [model\_name](#output\_model\_name) | Model name for the deployed controller. |
| <a name="output_nats_offer_url"></a> [nats\_offer\_url](#output\_nats\_offer\_url) | Juju offer url for connecting to the NATS charm. |
<!-- END_TF_DOCS -->
