## Usage
The module can deploy a number of anbox subclusters per juju region using the
variable `var.subclusters_per_region`. To execute the terraform plan:

> Note: You need to have juju controller bootstrapped and a juju client
> configured on your local system to be able to use the plan.

* Create a file called `anbox.tfvars` and set the values for the variables e.g

```tfvars
ubuntu_pro_token = "<pro_token_here>"
anbox_channel    = "1.26/edge"
subclusters = [
  {
    name           = "a"
    lxd_node_count = 1
    registry = {
      mode = "client"
    }
  }
]
ssh_key_path = "~/.ssh/id_rsa.pub"
deploy_registry = true
enable_ha = false
enable_cos = false
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

## Known Issues
- COS Support: This plan does not create integrations for the grafana agent charm. This is because the Juju Terraform provider [does not](https://github.com/juju/terraform-provider-juju/issues/119) support cross-controller model relations.
- `var.constraints` may not work properly and needs to be specified to keep terraform consistent even when default constraints are being filled by Juju. [#344](https://github.com/juju/terraform-provider-juju/issues/344), [#632](https://github.com/juju/terraform-provider-juju/issues/632)
- The plan might see failures from juju when running terraform with default parallelism. It is recommended to run terraform with `-parallelism=1` for most consistent results.

## Contributing
### Generate Docs
This repository uses [terraform docs](https://terraform-docs.io/) to generate
the docs. To generate docs run:

```shell
./scripts/generate-docs.sh
```

