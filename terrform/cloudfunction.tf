# Generates an archive of the source code compressed as a .zip file.
data "archive_file" "source" {
  type        = "zip"
  source_dir  = "../src"
  output_path = "${path.module}/function.zip"
}

# Add source code zip to the Cloud Function's bucket (Cloud_function_bucket) 
resource "google_storage_bucket_object" "zip" {
  source       = data.archive_file.source.output_path
  content_type = "application/zip"
  name         = "src-${data.archive_file.source.output_md5}.zip"
  bucket       = google_storage_bucket.Cloud_function_bucket.id
  depends_on = [
    google_storage_bucket.Cloud_function_bucket,
    data.archive_file.source
  ]
}

# Create the Cloud function triggered by a `Finalize` event on the bucket
resource "google_cloudfunctions_function" "Cloud_function" {
  name                  = "Cloud-function-trigger-using-terraform"
  description           = "Cloud-function will get trigger once file is uploaded in input-${var.project_id}"
  runtime               = "python39"
  project               = var.project_id
  region                = var.region
  source_archive_bucket = google_storage_bucket.Cloud_function_bucket.id
  source_archive_object = google_storage_bucket_object.zip.name
  entry_point           = "fileUpload"
  event_trigger {
    event_type = "google.storage.object.finalize"
    resource   = "inputnavensingh"
  }
  depends_on = [
    google_storage_bucket.Cloud_function_bucket,
    google_storage_bucket_object.zip,
  ]
}
