terraform {
  backend "gcs" {
    bucket = "storbucket-test"
    prefix = "terraform/state"
  }
}
