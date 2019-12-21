variable "terraform_backend_type" {
  type        = string
  description = "The list of AWS providers."
  default     = "local"
}

variable "landing_zone_providers" {
  type        = map(map(string))
  description = "The list of AWS providers."
  default     = {}
}

variable "landing_zone_components" {
  type        = map(string)
  description = "This is the list of AWS Landing Zone components that will be deployed if corresponding `.tfvars` file is included."
}

variable "terraform_backend_config" {
  type        = map(string)
  description = "This is the backend configure for all components."
  default = {
    backend = "local"
    path    = "/tmp/.terrahub/landing_zone"
  }
}

variable "terraform_config" {
  type        = bool
  description = "The command that will be generate the `terraform` config file."
  default     = true
}

variable "terraform_redeploy" {
  type        = bool
  description = "The command that will be generate the `terraform` config file."
  default     = true
}

variable "terraform_output_path" {
  type        = string
  description = "The terraform aoutput path that will be used by `terrahub` in this component."
  default     = "~/.terrahub/cache/landing_zone/output.json"
}

variable "outputs_backend_config" {
  type        = map(string)
  description = "This is the backend configure for output component."
  default = {
    path = "/tmp/.terrahub/landing_zone/terrahub_load_outputs/terraform.tfstate"
  }
}
