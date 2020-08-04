provider "ignition" {
    # https://www.terraform.io/docs/providers/ignition/index.html
    version = "1.2.1"
}

locals {
    ignition_encoded = "data:text/plain;charset=utf-8;base64,${base64encode(var.bootstrap_ignition_url)}"
}

data "ignition_config" "ign" {
    append {
        source = "${var.bootstrap_ignition_url != "" ? var.bootstrap_ignition_url : local.ignition_encoded}"
    }
} 