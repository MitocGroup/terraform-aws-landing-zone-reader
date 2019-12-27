data "terraform_remote_state" "landing_zone_reader_output" {
  depends_on = [module.landing_zone_reader_config]

  backend = var.terraform_backend_type
  config  = var.terraform_backend_output
}
