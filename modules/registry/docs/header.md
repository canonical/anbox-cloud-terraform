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
