# terraform module `landing_zone_reader`
[AWS Landing Zone](https://aws.amazon.com/solutions/aws-landing-zone/) is
a solution that helps customers more quickly set up a secure, multi-account
AWS environment based on AWS best practices. This repository contains
terraform module `landing_zone_reader` that allows read-only access and
view into resources managed by terraform module `landing_zone`.

RELATED: [terraform module `landing_zone`](https://github.com/MitocGroup/terraform-aws-landing-zone)


## Usage Example
To get started, simply include the following terraform codebase:
```hcl
module "landing_zone_reader" {
  source  = "MitocGroup/landing-zone-reader/aws"
  version = "0.0.1"
  landing_zone_providers   = var.landing_zone_providers
  landing_zone_components  = var.landing_zone_components
  terraform_backend_type   = var.terraform_backend_type
  terraform_backend_config = var.terraform_backend_config
  terraform_reader_config  = var.terraform_reader_config
}
```
> NOTE: Make sure to include `variables.tf` and optionally `terraform.tfvars`

To simplify and make it easier to understand, we included default values in `terraform.tfvars`:
```hcl
landing_zone_providers = {
  default = {
    account_id = "123456789012"
    region     = "us-east-1"
  }
  [...]
}
landing_zone_components = {
  landing_zone_vpc = "s3://terraform-aws-landing-zone/components/landing_zone_vpc/*.tfvars"
  [...]
}
terraform_backend_type   = "s3"
terraform_backend_config = {
  bucket  = "terraform-aws-landing-zone"
  key     = "terraform/landing_zone_reader_output/terraform.tfstate"
  region  = "us-east-1"
}
terraform_reader_config = true
```

> NOTE: Placeholder `[...]` from above is used to suggest that similar syntax can be added. Remove it or update in order to have valid HCL / terraform configuration.

This means that before you use this terraform module, you will need to:
1. Change `landing_zone_providers` to values that describe your AWS Organization account
    * `default` reflects the default setup corresponding to AWS Organization account; add more providers by extending `landing_zone_providers` map with extra AWS accounts and/or AWS regions
        * `account_id` reflects the AWS account used to deploy AWS resources; prevents provisioning AWS resources into wrong AWS account in case of valid AWS credentials
        * `region` reflects the AWS region used to deploy AWS resources; create 2 different providers for the same AWS account, but different AWS regions
2. Change `landing_zone_components` to values that fit into your AWS Landing Zone use case
    * each key from `landing_zone_components` map represents the name of the component from [this list of available components](https://github.com/MitocGroup/terraform-aws-landing-zone/tree/master/components)
    * each value from `landing_zone_components` map represents the path to `.tfvars` file on S3 and/or local disk
        * each `.tfvars` file must use HCL format; DO NOT USE other formats like JSON or YAML
3. Change `terraform_backend_type` and `terraform_backend_config` to values that reflect your terraform backend where `.tfstate` files are stored (in `variables.tf` default parameter value is defined as `local`)

### More Examples
* [Terraform module for AWS Lambda function using AWS Landing Zone reader](https://github.com/MitocGroup/terraform-aws-landing-zone-reader/tree/master/examples/example_landing_zone_reader)


## Why to Use This Solution

### No need for code changes
Terraform module for AWS Landing Zone solution is up to 10 lines of code that receives a list of `.tfvars` files as input variables which describe providers (to be read: AWS accounts and AWS regions) and configs (to be read: AWS resources)

### No need for code rewrites
This implementation engages microservices architecture, allowing any component to be replaced with another component (or multiple components)

### No need for hard-coded values
Existing AWS resources created by your team can be reused programmatically as read only values by other teams' terraform configurations

### No need to rebuild from scratch
Existing AWS resources in your current AWS account(s) can be imported and reused without downtime by this terraform module via `terraform import` command

### No need to exclude pieces of account(s) baseline
Some customers were avoiding in the past AWS Landing Zone because it doesn't support some kind of 3rd party SSO solution or 3rd party Logging solution. By using terraform, we can easily bring those solutions into AWS Landing Zone as a set of components and empower customers to continue using best practices of both worlds

### Additionally, this module helps enforce best practices
- By removing the need for access to AWS root account(s)
- By using IAM cross-account roles and/or STS temporary credentials
- By enabling centralized CloudTrail logs and cross-region replication of CloudTrail logs
- By empowering complex organizations to separate roles and responsibilities (e.g. InfoSec team can place explicit deny on IAM, VPC, SG and STS for other teams and/or other environments like production or pre-production)
