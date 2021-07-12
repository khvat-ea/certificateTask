terraform {
  required_version = ">= 0.12"
}


#######################################################
# Create custom GCP instance
#######################################################
resource "google_compute_instance" "vm" {
  name         = "${var.name}"
  machine_type = format("%s%s%s%d","e2-custom-",var.cpu,"-",var.ram * 1024)
  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {
    }
  }

  # Write public key in to the metadata item GCP
  metadata = {
    ssh-keys = "root:${file("${var.public_key_path}")}"
  }
}


##############################################
# Set firewall rules (Use "default" network!)
##############################################
module "firewall_rules" {
  depends_on = [resource.google_compute_instance.vm]
  source       = "terraform-google-modules/network/google//modules/firewall-rules"
  project_id   = resource.google_compute_instance.vm.project
  network_name = "default"

  rules = [{
    name                    = format("%s%s", "allow-tcp-ingress-", resource.google_compute_instance.vm.name)
    description             = null
    direction               = "INGRESS"
    priority                = null
    ranges                  = ["0.0.0.0/0"]
    source_tags             = null
    source_service_accounts = null
    target_tags             = null
    target_service_accounts = null
    allow = [{
      protocol = "tcp"
      ports    = "${var.allow_ports}"
    }]
    deny = []
    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }]
}