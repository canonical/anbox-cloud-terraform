# Anbox Cloud Terraform

This is a terraform module to deploy anbox controller model using juju and terraform.
The module uses `terraform-provider-juju` to deploy the anbox charm to a
juju model.

### Some features of the deployment

* The module deploys a control plane for anbox cloud. The control plane currently
includes:
- NATS
- Anbox Cloud Gateway
- Certificate Authority (CA: self-signed-certificates)
- Anbox Cloud Dashboard

### Some limitations of the plan

* The terraform plan does not support deploying juju applications on the same machine.
This is due to the fact that `placement` support for juju application is currently
a known issue [#443](https://github.com/juju/terraform-provider-juju/issues/443).
