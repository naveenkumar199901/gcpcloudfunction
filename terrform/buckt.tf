resource "google_storage_bucket" "Cloud_function_bucket" {
  name     = "cloudfunctionnaveensingh"
  location = var.region
  project  = var.project_id
}

resource "google_storage_bucket" "input_bucket" {
  name     = "inputnavensingh"
  location = var.region
  project  = var.project_id
}
