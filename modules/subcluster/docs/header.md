# Anbox Cloud Subcluster

This is a terraform module to deploy anbox cloud subcluster using juju and terraform.
The module uses `terraform-provider-juju` to deploy the anbox charm to a
juju model.

### Some features of the deployment

* The module logically divides resources into a control plane and a data plane.
* The control plane currently includes:
- AMS
- ETCD (optional)
- EasyRSA (optional)
- Anbox Stream Agent
- Coturn
* The data plan includes:
- LXD
- AMS-Node-Controller
* This module can deploy a number of LXD machines to act as nodes to AMS using the
input variable `var.lxd_nodes`.
* Each LXD node is accompanied by a subordinate charm `ams-node-controller` to
setup network rules properly on the lxd node.

### Some limitations of the plan

* The terraform plan does not support deploying juju applications on the same machine.
This is due to the fact that `placement` support for juju application is currently
a known issue [#443](https://github.com/juju/terraform-provider-juju/issues/443).
