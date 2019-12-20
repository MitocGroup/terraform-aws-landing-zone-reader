variable "root_path" {
  type        = string
  description = "The path of root directory."
}

variable "landing_zone_providers" {
  type        = map(map(string))
  default     = {}
  description = "The list of AWS providers."
}

variable "landing_zone_components" {
  type        = map(string)
  description = "This is the list of AWS Landing Zone components that will be deployed if corresponding `.tfvars` file is included."
}

variable "terraform_config" {
  type        = bool
  default     = true
  description = "The command that will be generate the `terraform` config file."
}

variable "terraform_redeploy" {
  type        = bool
  default     = true
  description = "The command that will be generate the `terraform` config file."
}

variable "terraform_output_path" {
  type        = string
  default     = "~/.terrahub/cache/landing_zone/output.json"
  description = "The terraform aoutput path that will be used by `terrahub` in this component."
}

variable "terraform_backend" {
  type        = map(string)
  description = "This is the backend configure for all components."
  default = {
    backend = "local"
    path    = "/tmp/.terrahub/landing_zone"
  }
}
