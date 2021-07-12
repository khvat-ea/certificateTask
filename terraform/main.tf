terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.74.0"
    }
  }
}

provider "google" {
  project = "devops-school-317412"
  region  = "us-central1"
  zone    = "us-central1-c"
}


#######################################################
# Create builder instance
#######################################################
module "srv_build" {
  source = "./modules/instance"
  public_key_path = "${var.public_key_path}"
  private_key_path = "${var.private_key_path}"
  name = "builder"
  cpu = 2
  ram = 2
  image = "ubuntu-os-cloud/ubuntu-2004-lts"
}

#######################################################
# Create production instance
#######################################################
module "srv_prod" {
  # Set start order. After build
  depends_on = [module.srv_build]

  source = "./modules/instance"
  public_key_path = "${var.public_key_path}"
  private_key_path = "${var.private_key_path}"
  name = "production"
  cpu = 2
  ram = 2
  image = "ubuntu-os-cloud/ubuntu-2004-lts"
}