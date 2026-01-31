
# Terraform Interview Questions and Answers

## Terraform Folder Structure

A typical Terraform project structure helps in organizing your code, making it more maintainable and scalable.

```
.
├── main.tf         # Main entry point, contains the core resource definitions
├── variables.tf    # Contains variable declarations
├── outputs.tf      # Contains output value definitions
├── terraform.tfvars  # Contains variable value assignments (for a specific environment)
├── providers.tf    # Contains provider configurations (e.g., AWS, Azure, GCP)
└── modules/        # Directory for reusable modules
    └── web_server/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

- **`main.tf`**: This is where the primary set of configurations for your infrastructure resides.
- **`variables.tf`**: Declares all the input variables for the project.
- **`outputs.tf`**: Defines the output values from your resources, which can be useful for other Terraform configurations or for users to query.
- **`terraform.tfvars`**: This file is used to provide values to the variables declared in `variables.tf`. You can have different `.tfvars` files for different environments (e.g., `dev.tfvars`, `prod.tfvars`).
- **`providers.tf`**: It's a good practice to define your providers and their versions in a separate file.
- **`modules/`**: This directory contains reusable modules. Each subdirectory within `modules/` represents a separate module.

## Terraform Lifecycle

The Terraform lifecycle consists of several stages:

1.  **`terraform init`**: Initializes a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration. It downloads and installs providers, initializes the backend, and downloads any modules.
    ```bash
    terraform init
    ```
2.  **`terraform plan`**: Creates an execution plan. Terraform determines what actions are necessary to achieve the desired state specified in the configuration files. This is a dry run and shows you what changes will be made.
    ```bash
    terraform plan
    ```
3.  **`terraform apply`**: Applies the changes required to reach the desired state of the configuration. It will create, update, or delete resources as necessary.
    ```bash
    terraform apply
    ```
4.  **`terraform destroy`**: Destroys all the resources managed by the Terraform configuration.
    ```bash
    terraform destroy
    ```

## How to create Terraform modules?

Modules in Terraform are self-contained packages of Terraform configurations that are managed as a group.

To create a module, you create a new directory and place one or more `.tf` files inside. For example, to create a module for an AWS S3 bucket:

`modules/s3-bucket/main.tf`:
```terraform
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  acl    = "private"

  tags = {
    Name = var.bucket_name
  }
}
```

`modules/s3-bucket/variables.tf`:
```terraform
variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}
```

To use this module in your main configuration:

`main.tf`:
```terraform
module "my_s3_bucket" {
  source      = "./modules/s3-bucket"
  bucket_name = "my-unique-app-bucket"
}
```

## How to get a backup of the state file in Terraform?

The best way to manage state file backups is to use a **remote backend** like AWS S3, Azure Blob Storage, or HashiCorp Consul. These backends automatically handle state file backups, versioning, and locking.

Example with AWS S3 backend in `providers.tf`:
```terraform
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "my-terraform-locks"
    encrypt        = true
  }
}
```
With this configuration, S3 will version your state file, so you can always revert to a previous version if needed.

If you are using a local state file, you can manually back it up:
```bash
cp terraform.tfstate terraform.tfstate.backup
```
However, this is not recommended for production environments.

## What is configuration drift in Terraform? And how to resolve it?

**Configuration drift** occurs when your Terraform configuration files (`.tf`) do not match the desired state of your infrastructure. This usually happens when developers make changes to the Terraform code but don't apply them.

**Resolution**:
1.  Run `terraform plan`. This will show you the difference between your configuration and the currently deployed infrastructure (as recorded in the state file).
2.  Run `terraform apply` to apply the changes and bring the infrastructure in line with your configuration.

## What is state drift in Terraform? And how to resolve it?

**State drift** occurs when the actual state of your infrastructure on the cloud provider differs from what is recorded in the Terraform state file. This is usually caused by manual changes made to the infrastructure outside of Terraform (e.g., through the cloud provider's console).

**Resolution**:
1.  Run `terraform plan`. Terraform will detect the drift and show you the changes it wants to make to revert the manual changes.
2.  To update the state file to match the real-world infrastructure, you can use `terraform apply -refresh-only`.
3.  Alternatively, you can accept the changes proposed by `terraform plan` and run `terraform apply` to bring the infrastructure back to the state defined in your configuration.

## Difference between Configuration drift and state drift in Terraform?

| Feature             | Configuration Drift                                 | State Drift                                           |
| ------------------- | --------------------------------------------------- | ----------------------------------------------------- |
| **Source of Truth** | Terraform configuration files (`.tf`) are the source of truth. | Terraform state file (`.tfstate`) is the source of truth. |
| **Cause**           | Changes made to `.tf` files but not applied.        | Manual changes made to infrastructure outside of Terraform. |
| **Detection**       | `terraform plan` shows changes to be applied.       | `terraform plan` shows resources have been changed externally. |
| **Resolution**      | `terraform apply` to apply the configuration changes. | `terraform apply` to revert manual changes, or `terraform import` to update the state. |

## How to do terraform multienvironment or multiregion deployment?

There are several strategies for managing multiple environments:

1.  **Workspaces**: Terraform workspaces allow you to have multiple state files for the same configuration.
    ```bash
    terraform workspace new dev
    terraform workspace new prod
    terraform workspace select dev
    terraform apply -var-file="dev.tfvars"
    ```
2.  **Directory Structure**: Create a separate directory for each environment.
    ```
    ├── environments/
    │   ├── dev/
    │   │   ├── main.tf
    │   │   └── terraform.tfvars
    │   └── prod/
    │       ├── main.tf
    │       └── terraform.tfvars
    ```
3.  **Using `.tfvars` files**: Use different variable files for each environment.
    ```bash
    terraform apply -var-file="dev.tfvars"
    terraform apply -var-file="prod.tfvars"
    ```

For multi-region deployments, you can pass the region as a variable and create modules that are region-aware.

## What is the `for_each` meta-argument in Terraform?

The `for_each` meta-argument is used to create multiple instances of a resource or module based on the elements of a map or a set of strings. It's useful when you need to create similar resources with different properties.

Example:
```terraform
variable "s3_buckets" {
  type = set(string)
  default = ["bucket-one", "bucket-two"]
}

resource "aws_s3_bucket" "example" {
  for_each = var.s3_buckets
  bucket   = each.key
}
```
This will create two S3 buckets, `bucket-one` and `bucket-two`.

## What is the `count` meta-argument in Terraform?

The `count` meta-argument is used to create a specified number of instances of a resource or module.

Example:
```terraform
resource "aws_instance" "server" {
  count         = 3
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "Server ${count.index}"
  }
}
```
This will create three identical EC2 instances.

## Difference between `for_each` and `count`?

| Feature         | `for_each`                                                              | `count`                                                                 |
| --------------- | ----------------------------------------------------------------------- | ----------------------------------------------------------------------- |
| **Input**       | A map or a set of strings.                                              | A whole number.                                                         |
| **Identifiers** | Each instance is identified by the key of the map or the value of the set. | Each instance is identified by its index (e.g., `[0]`, `[1]`).          |
| **Changes**     | If an item is removed from the map/set, only that specific resource is destroyed. | If you remove an item from the middle of a list, it can cause resources to be destroyed and recreated. |
| **Use Case**    | Best for managing a collection of distinct objects.                     | Best for creating multiple similar resources where the individual identity is not critical. |

## One of the team members deleted a few resources from the cloud, what happens to the state file?

The state file becomes out of sync with the real-world infrastructure. This is an example of **state drift**. The next time you run `terraform plan`, Terraform will detect that the resources defined in the state file no longer exist in the cloud and will propose to recreate them.

## What is `locals` in Terraform?

`locals` are used to define local variables within a module. They can be used to simplify your code by giving names to complex expressions or to reduce repetition.

Example:
```terraform
locals {
  common_tags = {
    Owner   = "DevOps-Team"
    Project = "WebApp"
  }
}

resource "aws_instance" "web" {
  # ...
  tags = local.common_tags
}
```

## What is the use of `workspace` in Terraform?

Workspaces in Terraform allow you to manage multiple, distinct sets of infrastructure with the same configuration. Each workspace has its own state file, which means you can have different environments (like `dev`, `staging`, `prod`) that are managed by the same Terraform code but have completely separate resources.

## What is the `terraform refresh` command?

The `terraform refresh` command reconciles the state Terraform knows about (via the state file) with the real-world infrastructure. It updates the state file to match any changes made outside of Terraform. This command is now deprecated and its functionality is part of `terraform plan` and `terraform apply`. To get the old behavior, you can use `terraform apply -refresh-only`.

## How does Terraform handle immutable infrastructure?

Terraform promotes the concept of immutable infrastructure. Instead of modifying existing resources in-place, Terraform prefers to create new resources with the updated configuration and then destroy the old ones. When you change a property of a resource that cannot be updated in-place (e.g., the AMI of an EC2 instance), `terraform plan` will show that the old resource will be destroyed and a new one will be created.

## Suppose my state file is corrupted, how to fix it?

1.  **Restore from Backup**: If you are using a remote backend with versioning, you can restore a previous, known-good version of the state file.
2.  **Manual Edit**: For minor corruptions, you can manually edit the `terraform.tfstate` file (this is risky and should be a last resort).
3.  **`terraform import`**: You can use the `terraform import` command to import existing infrastructure back into your state file. This is a more systematic way to rebuild your state.
4.  **`terraform state` command**: The `terraform state` command provides subcommands for advanced state management, like `terraform state pull`, `terraform state push`, and `terraform state rm`.

## How is the state file in Terraform getting locked?

State locking is a feature that prevents others from running Terraform commands that could modify the state while you are running an operation. This is crucial for teams working on the same infrastructure.

-   When you run `terraform apply`, Terraform places a lock on the state file.
-   If another user tries to run `terraform apply` at the same time, they will see a message that the state is locked and will have to wait until the first operation is complete.
-   Remote backends like AWS S3 (with DynamoDB for locking), Azure Blob Storage, and HashiCorp Consul provide robust locking mechanisms.

## We need dev, QA, and Prod with different instance sizes. How to design it properly?

This is a perfect use case for workspaces and `.tfvars` files.

1.  **Use Workspaces**:
    ```bash
    terraform workspace new dev
    terraform workspace new qa
    terraform workspace new prod
    ```

2.  **Define a variable for instance type in `variables.tf`**:
    ```terraform
    variable "instance_type" {
      description = "The EC2 instance type"
      type        = string
    }
    ```

3.  **Create `.tfvars` files for each environment**:
    `dev.tfvars`:
    ```
    instance_type = "t2.micro"
    ```
    `qa.tfvars`:
    ```
    instance_type = "t2.medium"
    ```
    `prod.tfvars`:
    ```
    instance_type = "m5.large"
    ```

4.  **Apply the configuration for each environment**:
    ```bash
    terraform workspace select dev
    terraform apply -var-file="dev.tfvars"

    terraform workspace select qa
    terraform apply -var-file="qa.tfvars"
    ```

## Our Terraform has a DB password, how to secure it?

Never hardcode secrets like passwords in your Terraform files. Use a secrets management tool.

1.  **HashiCorp Vault**: Use the Vault provider for Terraform to fetch secrets at runtime.
    ```terraform
    data "vault_generic_secret" "db" {
      path = "secret/data/database"
    }

    resource "aws_db_instance" "default" {
      # ...
      password = data.vault_generic_secret.db.data["password"]
    }
    ```
2.  **AWS Secrets Manager** or **Azure Key Vault**: Use data sources to fetch secrets from these services.
    ```terraform
    data "aws_secretsmanager_secret_version" "db_password" {
      secret_id = "my-db-password-secret"
    }

    resource "aws_db_instance" "default" {
      # ...
      password = data.aws_secretsmanager_secret_version.db_password.secret_string
    }
    ```
3.  **Environment Variables**: You can pass secrets as environment variables.
    ```bash
    export TF_VAR_db_password="mysecretpassword"
    ```
    Then in your `variables.tf`:
    ```terraform
    variable "db_password" {
      type      = string
      sensitive = true
    }
    ```
    The `sensitive = true` flag prevents Terraform from showing the value in logs and outputs.

## Two members ran `terraform apply` at the same time. The infrastructure got partially updated. What happened? How do we fix it in production?

**What happened**: This scenario happens when state locking is not enabled or is not working correctly. Without a lock, both `apply` operations read the same initial state file, and both proceed to make changes, unaware of each other. The last one to finish writing to the state file "wins," potentially overwriting the state changes made by the other, leading to a state file that only partially reflects the true state of the infrastructure.

**How to fix it**:
1.  **Enable State Locking Immediately**: The first step is to prevent this from happening again. Configure a remote backend with a reliable locking mechanism (e.g., S3 with DynamoDB).
2.  **Assess the Damage**: Run `terraform plan`. This will show the difference between the (now incorrect) state file and the actual infrastructure. The plan will likely propose to create, delete, or modify resources to match the inconsistent state.
3.  **Reconcile the State**: Do not blindly run `terraform apply`. Carefully review the plan. You may need to manually reconcile the state file with the real world using:
    -   `terraform import`: To bring unmanaged resources (created by one of the conflicting applies but not in the final state file) under Terraform's management.
    -   `terraform state rm`: To remove resources from the state that were deleted from the cloud but still exist in the state file.
4.  **Run `terraform apply`**: Once the state file accurately reflects the desired state of the infrastructure, run `terraform apply` to converge everything to the configuration defined in your `.tf` files.
