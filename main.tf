module "landing_zone" {
  source                  = "./modules/landing_zone_reader"
  landing_zone_providers  = {}
  landing_zone_components = {}
  terraform_config        = false
}

module "landing_zone_reader_config" {
  source                  = "./modules/landing_zone_reader_config"
  root_path               = path.module
  landing_zone_providers  = var.landing_zone_providers
  landing_zone_components = var.landing_zone_components
  terraform_backend       = var.terraform_backend_config
  terraform_output_path   = var.terraform_output_path
  terraform_redeploy      = var.terraform_redeploy
}
