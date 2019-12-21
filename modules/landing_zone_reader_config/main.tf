resource "null_resource" "terraform_output" {
  provisioner "local-exec" {
    command = "touch ${pathexpand(var.terraform_output_path)}"
  }
}

resource "null_resource" "terraform_config" {
  depends_on = [null_resource.terraform_output]
  triggers = {
    config = var.terraform_config
    sample = ".terrahub.yml.sample"
    root   = ".terrahub.yml"
  }

  provisioner "local-exec" {
    when    = create
    command = self.triggers.config ? "mv ${self.triggers.sample} ${self.triggers.root}" : "echo 'Root .terrahub.yml is ignored!'"
  }
}

resource "null_resource" "landing_zone_reader_config" {
  depends_on = [null_resource.terraform_config]
  count = var.terraform_redeploy ? 1 : 0

  triggers = {
    module_path = path.module
    root_path   = var.root_path
    providers   = jsonencode(var.landing_zone_providers)
    components  = jsonencode(var.landing_zone_components)
    backend     = jsonencode(var.terraform_backend)
  }

  provisioner "local-exec" {
    when    = create
    command = <<-EOC
      node ${self.triggers.module_path}/scripts/config.js
    EOC

    environment  = {
      MODULE_PATH = self.triggers.module_path
      ROOT_PATH   = self.triggers.root_path
      PROVIDERS   = self.triggers.providers
      COMPONENTS  = self.triggers.components
      BACKEND     = self.triggers.backend
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOD
      node ${self.triggers.module_path}/scripts/remove-config.js
    EOD

    environment = {
      ROOT_PATH  = self.triggers.root_path
      COMPONENTS = self.triggers.components
    }
  }
}

resource "null_resource" "landing_zone_reader_apply" {
  depends_on = [null_resource.landing_zone_reader_config]
  count = var.terraform_redeploy ? 1 : 0

  triggers = {
    module_path = path.module
    root_path   = var.root_path
    components  = jsonencode(var.landing_zone_components)
    backend     = jsonencode(var.terraform_backend)
    timestamp   = timestamp()
  }

  provisioner "local-exec" {
    when    = create
    command = <<-EOC
      node ${self.triggers.module_path}/scripts/apply.js
    EOC

    environment = {
      ROOT_PATH  = self.triggers.root_path
      COMPONENTS = self.triggers.components
      BACKEND    = self.triggers.backend
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<-EOD
      echo 'info: destroy action ignored because part of landing_zone_reader_apply'
    EOD
  }
}
