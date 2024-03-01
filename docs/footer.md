## Usage
The module can deploy a number of anbox subclusters per juju region using the
variable `var.subclusters_per_region`. To execute the terraform plan:

> Note: You need to have juju controller bootstrapped and a juju client
> configured on your local system to be able to use the plan.

* Create a file called `anbox.tfvars` and set the values for the variables e.g

```tfvars
ua_token = "<pro_token_here>"
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

