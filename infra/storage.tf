resource "google_storage_bucket" "fotos" {
  name          = "${var.proyecto}-${var.prefijo}-fotos"
  location      = var.region
  storage_class = "STANDARD"

  uniform_bucket_level_access = true

  public_access_prevention = "enforced"

  force_destroy = true

  # Limpieza automática: el bucket borra solo los objetos (originales y
  # miniaturas) con más de 7 días desde su creación. Cloud Storage evalúa las
  # reglas de forma asíncrona, aproximadamente una vez al día, así que un objeto
  # puede sobrevivir unas horas más después de cumplir los 7 días.
  lifecycle_rule {
    condition {
      age = 7
    }
    action {
      type = "Delete"
    }
  }

  depends_on = [google_project_service.apis]
}

resource "google_storage_bucket_iam_member" "backend_objetos" {
  bucket = google_storage_bucket.fotos.name
  role   = "roles/storage.objectUser"
  member = google_service_account.backend.member
}