output "landing_zone_reader" {
  depends_on = [data.terraform_remote_state.landing_zone_reader_output]

  sensitive   = true
  value       = data.terraform_remote_state.landing_zone_reader_output.outputs.terrahub_reader
  description = "The map of all output variables from components."
}
