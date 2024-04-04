variable "credential" {
  description = "My credentials"
  default     = "./keys/my-creds.json"
}

variable "project" {
  description = "My project_id"
  default     = "elaborate-tube-412620"
}

variable "region" {
  description = "My region"
  default     = "us-central1"
}

variable "bucket" {
  description = "GCS bucket name"
  default     = "denge-bucket"
}

variable "location" {
  description = "Project location"
  default     = "US"
}

variable "bigquery_dataset_name" {
  description = "My BigQuery dataset name"
  default     = "dengue_dataset"
}