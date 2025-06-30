# Terraform Useful Commands

## Terraform Validate
```bash
tf validate     # validate the configuration for syntax validity
```

## Terraform Format
```bash
tf fmt      # format the configuration files to standardize style
```

## Terraform Init
```bash
tf init      # initialize terraform config files

tf init -upgrade        # upgrade to the latest provider
```

## Envrionment Variable
```bash
setx TF_VAR_instancetype m5.large       # set a variable via environment variable (Windows)

export TF_VAR_instancetype="t2.nano"        # set a variable via environment variable (Linux)
```

## Terraform Get
```bash
tf get      # install and update modules
```

## Terraform Plan
```bash
tf plan     # pre-deployment plan

tf plan -out=newplan    # save the plan to a file

tf plan -var="instancetype=t2.small"        # explicitly define variable value

tf plan -var-file="custom.tfvars"       # use custom tfvars file name

tf plan -target aws_security_group.sg_allow_ssh     # detect changes in a specific resource

tf plan -refresh=false      # skip the refresh of all resources in the configuration

tf plan -destroy        # plan a destroy without committing
```

## Terraform Apply
```bash
tf apply    # prompt before creating resources described in tf

tf apply --auto-approve     # create resources without prompt

tf apply "newplan"      # apply plan from plan file
```

## Terraform Destroy
```bash
tf destroy      # destroy all

tf destroy -target aws_instace.my_instance      # only destroy specific resource
```

## Terraform Taint
```bash
tf taint aws_instance.myec2     # mark ec2 instance to destroy and recreate on next apply
```

## Terraform State
```bash
tf state show aws_eip.myeip    # inspect the state of an elastic ip resource

tf state list   # list the resources in the state file

tf state refresh      # refresh the current state

```

## Terraform Graph
```bash
tf graph    # visual dependency graph
```

## Terraform Output
```bash
tf output iam_arm       # output the value iam_arn specified within the output configuration
```


## Logging
```bash
export TF_LOG=TRACE     # enable trace logging

export TF_LOG_PATH="terraform.txt"      # set log path to output to a file
```

## Comments
```hcl
/*
resource "digitalocean_droplet" "my_droplet" {
    image = "ubuntu-18-04-x64"
    name = "web-1"
    region = "nyc1"
    size = "s-1vcpu-1gb"
}
*/
```

