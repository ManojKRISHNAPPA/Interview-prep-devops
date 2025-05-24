## 1. What happens if your Terraform state file is accidentally deleted?
- Terraform loses track of all existing resources. On the next `terraform apply`, it may attempt to recreate all resources, causing duplication or conflicts. You should restore the state file from a backup or re-import the resources using `terraform import`.

## 2. What happens if multiple team members run `terraform apply` at the same time?
- If state locking is not enabled (e.g., using DynamoDB with S3), this can corrupt the state file. Only one apply should be allowed at a time to ensure safe and consistent updates. Enable state locking to prevent race conditions.

## 3. What happens if a resource creation fails halfway through `terraform apply`?
- Terraform stops the apply process immediately on failure. Successfully created resources remain, and the failed resource will be retried on the next apply unless fixed or removed.

## 4. What happens when AWS API rate limits are hit during a large `terraform apply`?
- Terraform retries failed requests with exponential backoff. If the limit continues to be exceeded, the apply will fail. Any successfully created resources stay in place, resulting in a partial deployment.

## 5. What happens if `terraform plan` shows no changes but infrastructure was modified manually?
- Terraform will not detect drift unless you run `terraform refresh` or `terraform plan -refresh-only`. This can lead to unpredictable behavior or conflicts in future applies.

## 6. What happens if you delete a resource from your Terraform configuration but not from the cloud?
- Terraform marks that resource for destruction on the next `terraform apply`. If you want to stop managing it without deletion, use `terraform state rm`.

## 7. What happens if you update the Terraform provider to a newer version with breaking changes?
- Terraform may fail to plan or apply, depending on the change. You may need to update your configuration to match the new provider requirements or use version pinning to avoid unexpected issues.

## 8. What happens if there's a circular dependency between two Terraform modules?
- Terraform will fail with a cycle error, stating it cannot determine a valid resource creation order. You must refactor the modules or use intermediate outputs to break the cycle.

## 9. What happens if you exceed AWS service quotas (e.g., EC2 instances or IPs)?
- Terraform will fail to create new resources that exceed the quotas. You must request an increase from AWS and then re-run `terraform apply`.

## 10. What happens if you lose access to the remote backend storing your Terraform state?
- Terraform cannot read or write state, making operations like plan and apply impossible. You must restore backend access or manually recover state from a backup.
