terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.22.0"
    }
  }
}

provider "google" {
  credentials = file(var.credential)
  project     = var.project
  region      = var.region
}

# GCS bucket creation 
#(see docs: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket)

resource "google_storage_bucket" "dengue-bucket" {
  name          = "${var.project}-${var.bucket}"             #variable concatenation
  location      = var.location
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 20
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

# BigQuery dataset creation
# (see docs: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset)

resource "google_bigquery_dataset" "dengue-dataset" {
  dataset_id                 = var.bigquery_dataset_name
  location                   = var.location
  delete_contents_on_destroy = true
}