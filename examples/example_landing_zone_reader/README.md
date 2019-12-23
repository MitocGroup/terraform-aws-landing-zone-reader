# example_landing_zone_reader
This example implements fully functional terraform configuration that can create (or update) `hello_world` AWS Lambda function using subnets and security groups programmatically retrieved by `landing_zone_reader` module.

## Example Usage

This module can be used as easy as:
```hcl
module "example_landing_zone_reader" {
  source                   = "MitocGroup/landing-zone-reader/aws"
  terraform_backend_type   = var.terraform_backend_type
  terraform_backend_config = var.terraform_backend_config
  terraform_reader_config  = var.terraform_reader_config
  landing_zone_providers   = var.landing_zone_providers
  landing_zone_components  = var.landing_zone_components
}
```

For easier usage and reduced complexity, we recommend to define `locals` as show below:
```hcl
locals {
  landing_zone_iam_role_arns      = module.example_landing_zone_reader.landing_zone_reader["landing_zone_iam_role_arns"]
  landing_zone_subnet_ids         = module.example_landing_zone_reader.landing_zone_reader["landing_zone_subnet_ids"]
  landing_zone_security_group_ids = module.example_landing_zone_reader.landing_zone_reader["landing_zone_security_group_ids"]
}
```

Use above defined `locals` in your terraform resource as easy as:
```hcl
resource "aws_lambda_function" "hello_world" {
  function_name = "my_hello_world"
  description   = "Managed by TerraHub"
  runtime       = "nodejs10.x"
  handler       = "index.handler"
  memory_size   = "128"
  timeout       = "30"
  role          = local.landing_zone_iam_role_arns["default"]["ServiceRoleForLambdaEdge"]
  s3_bucket     = "www.terrahub.io"
  s3_key        = "/hello-world/nodejs10.x.zip"

  vpc_config = {
    subnet_ids         = values(local.landing_zone_subnet_ids["default"])
    security_group_ids = values(local.landing_zone_security_group_ids["default"])
  }
}
```

## Input / Arguments Reference
The following arguments / input parameters are expected by AWS Lambda function resource:

Name | Required? | Description
-----|-----------|------------
source | Required | All modules require a source argument, which is a meta-argument defined by Terraform CLI. Its value is either the path to a local directory of the module's configuration files, or a remote module source that Terraform should download and use. This value must be a literal string with no template sequences; interpolations are not allowed.
version | Optional | A version constraint string that specifies which versions of the referenced module are acceptable. The newest version matching the constraint will be used. version is supported only for modules retrieved from module registries.
providers | Optional | A map whose keys are provider configuration names that are expected by child module and whose values are corresponding provider names in the calling module. This allows provider configurations to be passed explicitly to child modules. If not specified, the child module inherits all of the default (un-aliased) provider configurations from the calling module.
filename | Optional | The path to the function's deployment package within the local filesystem. If defined, The s3_-prefixed options cannot be used.
s3_bucket | Optional | The S3 bucket location containing the function's deployment package. Conflicts with filename. This bucket must reside in the same AWS region where you are creating the Lambda function.
s3_key | Optional | The S3 key of an object containing the function's deployment package. Conflicts with filename.
s3_object_version | Optional | The object version containing the function's deployment package. Conflicts with filename.
function_name | Required | A unique name for your Lambda Function.
dead_letter_config | Optional | Nested block to configure the function's dead letter queue. See details below.
handler | Required | The function entrypoint in your code.
role | Required | IAM role attached to the Lambda Function. This governs both who / what can invoke your Lambda Function, as well as what resources our Lambda Function has access to. See Lambda Permission Model for more details.
description | Optional | Description of what your Lambda Function does.
layers | Optional | List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function. See Lambda Layers
memory_size | Optional | Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128. See Limits
runtime | Required | See Runtimes for valid values.
timeout | Optional | The amount of time your Lambda Function has to run in seconds. Defaults to 3. See Limits
reserved_concurrent_executions | Optional | The amount of reserved concurrent executions for this lambda function. A value of 0 disables lambda from being triggered and -1 removes any concurrency limitations. Defaults to Unreserved Concurrency Limits -1. See Managing Concurrency
publish | Optional | Whether to publish creation/change as new Lambda Function Version. Defaults to false.
vpc_config | Optional | Provide this to allow your function to access your VPC. Fields documented below. See Lambda in VPC
environment | Optional | The Lambda environment's configuration settings. Fields documented below.
kms_key_arn | Optional | The ARN for the KMS encryption key.
source_code_hash | Optional | Used to trigger updates. Must be set to a base64-encoded SHA256 hash of the package file specified with either filename or s3_key. The usual way to set this is filebase64sha256("file.zip") (terraform 0.11.12 and later) or base64sha256(file("file.zip")) (terraform 0.11.11 and earlier), where "file.zip" is the local filename of the lambda function source archive.
tags | Optional | A mapping of tags to assign to the object.
dead_letter_config | | 
target_arn | Required | The ARN of an SNS topic or SQS queue to notify when an invocation fails. If this option is used, the function's IAM role must be granted suitable access to write to the target object, which means allowing either the sns:Publish or sqs:SendMessage action on this ARN, depending on which service is targeted.
tracing_config | | 
mode | Required | Can be either PassThrough or Active. If PassThrough, Lambda will only trace the request from an upstream service if it contains a tracing header with "sampled=1". If Active, Lambda will respect any tracing header it receives from an upstream service. If no tracing header is received, Lambda will call X-Ray for a tracing decision.
vpc_config | | 
subnet_ids | Required | A list of subnet IDs associated with the Lambda function.
security_group_ids | Required | A list of security group IDs associated with the Lambda function.
environment | | 
variables | Optional | A map that defines environment variables for the Lambda function.

## Output / Attributes Reference
The following attributes / output parameters are produced by AWS Lambda function resource:

Name | Description
-----|------------
landing_zone_reader | This map ( to be exact: map(map(map(any))) ) consolidates all outputs for each AWS resource created (or updated) in each AWS account (defined by `provider`) for each landing zone component (defined by `landing_zone_components`)
arn | The Amazon Resource Name (ARN) identifying your Lambda Function.
qualified_arn |  The Amazon Resource Name (ARN) identifying your Lambda Function Version (if versioning is enabled via publish = true).
invoke_arn | The ARN to be used for invoking Lambda Function from API Gateway - to be used in aws_api_gateway_integration's uri
version | Latest published version of your Lambda Function.
last_modified | The date this resource was last modified.
source_code_hash | Base64-encoded representation of raw SHA-256 sum of the zip file, provided either via filename or s3_* parameters.
source_code_size | The size in bytes of the function .zip file.
