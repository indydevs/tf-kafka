# Setup Terraform

1. Use `brew install terraform` to install terraform for mac

# Basic Setup
1. Add a profile to `~/.aws/credentials` or `~/.aws/config`
2. Create a new keypair inside the AWS region where the instance should be deployed
3. Enter `terraform plan` to verify the output and `terraform apply` to apply the changes
4. You will be prompted to enter the `aws_profile`, `aws_region`, `ami` and `key_name`. Once apply is complete, verify if you can ssh to the instance
5. Use `terraform destroy` to delete the instance setup in AWS
