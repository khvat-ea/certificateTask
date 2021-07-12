variable "public_key_path" {
  description = "Path to file containing public key"
}

variable "service_account_key" {
  description = "Path to file containing service account GCP key"
}

variable "project_GCP" {
  description = "GCP project ID"
}

variable "image_map" {
  description = "Choose image"
  type = map(string)
  default = {
    u16 = "ubuntu-os-cloud/ubuntu-1604-lts"
    u18 = "ubuntu-os-cloud/ubuntu-1804-lts"
    u20 = "ubuntu-os-cloud/ubuntu-2004-lts"
  }
} 