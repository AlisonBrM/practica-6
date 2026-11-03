resource "google_storage_bucket" "fotos" {
  name          = "${var.proyecto}-${var.prefijo}-fotos"
  location      = var.region
  storage_class = "STANDARD"

  uniform_bucket_level_access = true

  public_access_prevention = "enforced"

  force_destroy = true

  depends_on = [google_project_service.apis]
}

resource "google_storage_bucket_iam_member" "backend_objetos" {
  bucket = google_storage_bucket.fotos.name
  role   = "roles/storage.objectUser"
  member = google_service_account.backend.member
}