<!-- BEGIN_TF_DOCS -->
# Anbox Cloud Terraform

> [!WARNING]
> This terraform plan is a work in progress and makes use of [terraform-provider-juju](https://github.com/juju/terraform-provider-juju)
> which is in active development too. Please expect breaking changes (if required) in the future for the plan and the module.

This is a terraform plan to deploy anbox cloud using juju and terraform.
The module uses `terraform-provider-juju` to deploy the anbox bundles to a
bootstrapped juju cluster.

This plan uses terraform moudules to deploy an [anbox subcluster](./modules/subcluster/README.md)
and a [control plane](./modules/controller/README.md) for Anbox Cloud into two separate juju models.
The subclusters can be scaled up and down according to the requirements. The two terraform modules expose
the required attributes as outputs to be used to connect apps across the two juju models using
cross model relations.

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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_controller"></a> [controller](#module\_controller) | ./modules/controller | n/a |
| <a name="module_registry"></a> [registry](#module\_registry) | ./modules/registry | n/a |
| <a name="module_subcluster"></a> [subcluster](#module\_subcluster) | ./modules/subcluster | n/a |

## Resources

| Name | Type |
|------|------|
| [juju_integration.agent_nats_cmr](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |
| [juju_integration.dashboard_ams_cmr](https://registry.terraform.io/providers/juju/juju/latest/docs/resources/integration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_anbox_channel"></a> [anbox\_channel](#input\_anbox\_channel) | Channel to deploy anbox cloud charms from. | `string` | n/a | yes |
| <a name="input_constraints"></a> [constraints](#input\_constraints) | List of constraints that need to be applied to applications. Each constraint must be of format `<constraint_name>=<constraint_value>` | `list(string)` | `[]` | no |
| <a name="input_deploy_registry"></a> [deploy\_registry](#input\_deploy\_registry) | Deploy the Anbox Application Registry | `bool` | `false` | no |
| <a name="input_enable_ha"></a> [enable\_ha](#input\_enable\_ha) | Enable HA mode for anbox cloud | `bool` | `false` | no |
| <a name="input_subclusters"></a> [subclusters](#input\_subclusters) | "List of subclusters to deploy." | <pre>list(object({<br/>    name           = string<br/>    lxd_node_count = number<br/>    registry = optional(object({<br/>      enable = bool<br/>      mode   = optional(string)<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_ubuntu_pro_token"></a> [ubuntu\_pro\_token](#input\_ubuntu\_pro\_token) | Pro token used for anbox services | `string` | n/a | yes |

## Outputs

No outputs.

## Usage
The module can deploy a number of anbox subclusters per juju region using the
variable `var.subclusters_per_region`. To execute the terraform plan:

> Note: You need to have juju controller bootstrapped and a juju client
> configured on your local system to be able to use the plan.

* Create a file called `anbox.tfvars` and set the values for the variables e.g

```tfvars
ubuntu_pro_token = "<pro_token_here>"
subclusters_per_region = {
    ap-southeast-1 = 1
}
cloud_name = "aws"
constraints = [ "arch=arm64" ]
```

* Initialise the terraform directory

```shell
terraform init
```

* Create a terraform plan using

```shell
terraform plan -out=tfplan -var-file=anbox.tfvars
```

* Apply the terraform plan using

```shell
terraform apply tfplan
```

## Contributing
### Generate Docs
This repository uses [terraform docs](https://terraform-docs.io/) to generate
the docs. To generate docs run:

```shell
./scripts/generate-docs.sh
```
<!-- END_TF_DOCS -->
