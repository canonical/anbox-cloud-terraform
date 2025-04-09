# Anbox Cloud Terraform

> [!WARNING]
> This terraform plan is a work in progress and makes use of [terraform-provider-juju](https://github.com/juju/terraform-provider-juju)
> which is in active development too. Please expect breaking changes (if required) in the future for the plan and the module.


This is a terraform plan to deploy anbox cloud using juju and terraform.
The module uses `terraform-provider-juju` to deploy the anbox bundles to a
bootstrapped juju cluster.

This plan uses terroform moudules to deploy an [anbox subcluster](./modules/subcluster/README.md)
and a [control plane](./modules/controller/README.md) for Anbox Cloud into two separate juju models.
The subclusters can be scaled up and down according to the requirements. The two terraform modules expose
the required attributes as outputs to be used to connect apps across the two juju models using
cross model relations.

