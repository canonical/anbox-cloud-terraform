<!-- BEGIN_TF_DOCS -->
# Anbox Cloud Subcluster

This is a terraform module to deploy anbox cloud subcluster using juju and terraform.
The module uses `terraform-provider-juju` to deploy the anbox charm to a
juju model.

### Some features of the deployment

* The module logically divides resources into a control plane and a data plane.
* The control plane currently includes:
- AMS
- ETCD (optional)
- Self-signed-certificates (optional)
- Anbox Stream Agent
- Coturn
* The data plan includes:
- LXD
- AMS-Node-Controller
* This module can deploy a number of LXD machines to act as nodes to AMS using the
input variable `var.lxd_nodes`.
* Each LXD node is accompanied by a subordinate charm `ams-node-controller` to
setup network rules properly on the lxd node.

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
| [juju_application.agent](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.ams](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.ams_node_controller](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.ca](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.cos_agent](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.coturn](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.etcd](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_application.lxd](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_integration.agent_ams](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.agent_ca](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.ams_aar](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.ams_agent_streaming](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.ams_cos](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.ams_db](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.ams_lxd](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.coturn_agent](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.etcd_ca](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.ip_table_rules](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_machine.ams_node](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/machine) | resource |
| [juju_machine.db_node](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/machine) | resource |
| [juju_machine.lxd_node](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/machine) | resource |
| [juju_model.subcluster](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/model) | resource |
| [juju_offer.ams_offer](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/offer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_channel"></a> [channel](#input\_channel) | Channel for the deployed charm | `string` | `"latest/stable"` | no |
| <a name="input_constraints"></a> [constraints](#input\_constraints) | List of constraints that need to be applied to applications. Each constraint must be of format `<constraint_name>=<constraint_value>` | `list(string)` | `[]` | no |
| <a name="input_enable_cos"></a> [enable\_cos](#input\_enable\_cos) | Enable cos integration by deploying grafana-agent charm. | `bool` | `false` | no |
| <a name="input_enable_ha"></a> [enable\_ha](#input\_enable\_ha) | Number of lxd nodes to deploy per subcluster | `bool` | `false` | no |
| <a name="input_external_etcd"></a> [external\_etcd](#input\_external\_etcd) | Channel for the deployed charm | `bool` | `false` | no |
| <a name="input_lxd_nodes"></a> [lxd\_nodes](#input\_lxd\_nodes) | Channel for the deployed charm | `number` | `1` | no |
| <a name="input_model_suffix"></a> [model\_suffix](#input\_model\_suffix) | Suffix to attach for model | `string` | n/a | yes |
| <a name="input_registry_config"></a> [registry\_config](#input\_registry\_config) | Object to represent connection details for connecting to anbox registry | <pre>object({<br/>    mode      = string<br/>    offer_url = string<br/>  })</pre> | `null` | no |
| <a name="input_ubuntu_pro_token"></a> [ubuntu\_pro\_token](#input\_ubuntu\_pro\_token) | Pro token used to deploy AMS charm | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_agent_app_name"></a> [agent\_app\_name](#output\_agent\_app\_name) | Anbox Stream Agent application name deployed in the subcluster model. |
| <a name="output_ams_offer_url"></a> [ams\_offer\_url](#output\_ams\_offer\_url) | Juju offer url for connecting to the AMS charm. |
| <a name="output_model_name"></a> [model\_name](#output\_model\_name) | Model name for the deployed subcluster. |
<!-- END_TF_DOCS -->
