terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.74.0"
    }
  }
}

provider "google" {
  project = "${var.project_GCP}"
  region  = "us-central1"
  zone    = "us-central1-c"
  credentials = "${var.service_account_key}"
}


#######################################################
# Create builder instance:
# CPU = 2
# RAM = 2
# Image = Ubuntu 1804
#######################################################
module "srv_build" {
  source = "./modules/instance"
  public_key_path = "${var.public_key_path}"
  name = "builder"
  cpu = 2
  ram = 2
  image = "${var.image_map["u18"]}"
  allow_ports = ["22", "80", "443"]
}

#######################################################
# Create production instance
# CPU = 2
# RAM = 2
# Image = Ubuntu 1804
#######################################################
module "srv_prod" {
  # Set start order. After build
  depends_on = [module.srv_build]

  source = "./modules/instance"
  public_key_path = "${var.public_key_path}"
  name = "production"
  cpu = 2
  ram = 2
  image = "${var.image_map["u18"]}"
  allow_ports = ["22", "80", "443", "8080", "8090"]
}