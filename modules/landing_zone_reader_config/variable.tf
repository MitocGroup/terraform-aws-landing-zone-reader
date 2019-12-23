variable "root_path" {
  type        = string
  description = "The path of root directory."
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

variable "terraform_backend" {
  type        = map(string)
  description = "This is the backend configure for all components."
  default = {
    backend = "local"
    path    = "/tmp/.terrahub/landing_zone"
  }
}

variable "terraform_config" {
  type        = bool
  description = "If true, will generate root `.terrahub.yml` config."
  default     = true
}

variable "terraform_reader_config" {
  type        = bool
  description = "If true, will generate `landing_zone_reader_config`."
  default     = true
}

variable "terraform_output_path" {
  type        = string
  description = "The terraform aoutput path that will be used by `terrahub` in this component."
  default     = "/tmp/.terrahub/landing_zone/output.json"
}
