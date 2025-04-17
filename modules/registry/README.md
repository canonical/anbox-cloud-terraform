<!-- BEGIN_TF_DOCS -->
# Anbox Registry

This is a terraform module to deploy anbox registry model using juju and terraform.
The module uses `terraform-provider-juju` to deploy the anbox charm to a
juju model.

### Some features of the deployment

* The module deploys an Anbox Registry for anbox cloud. The model currently
includes:
- AAR (Anbox Application Registry)

### Some limitations of the plan

* The terraform plan does not support deploying juju applications on the same machine.
This is due to the fact that `placement` support for juju application is currently
a known issue [#443](https://github.com/juju/terraform-provider-juju/issues/443).

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.6 |
| <a name="requirement_juju"></a> [juju](#requirement\_juju) | ~> 0.18.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_juju"></a> [juju](#provider\_juju) | 0.18.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [juju_application.aar](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/application) | resource |
| [juju_model.registry](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/model) | resource |
| [juju_offer.client_offer](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/offer) | resource |
| [juju_offer.publisher_offer](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/offer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_channel"></a> [channel](#input\_channel) | Channel for the deployed charm | `string` | `"latest/stable"` | no |
| <a name="input_constraints"></a> [constraints](#input\_constraints) | List of constraints that need to be applied to applications. Each constraint must be of format `<constraint_name>=<constraint_value>` | `list(string)` | `[]` | no |
| <a name="input_enable_ha"></a> [enable\_ha](#input\_enable\_ha) | Number of lxd nodes to deploy per subcluster | `bool` | `false` | no |
| <a name="input_ubuntu_pro_token"></a> [ubuntu\_pro\_token](#input\_ubuntu\_pro\_token) | Pro token used to deploy AMS charm | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_client_offer_url"></a> [client\_offer\_url](#output\_client\_offer\_url) | n/a |
| <a name="output_publisher_offer_url"></a> [publisher\_offer\_url](#output\_publisher\_offer\_url) | n/a |
<!-- END_TF_DOCS -->