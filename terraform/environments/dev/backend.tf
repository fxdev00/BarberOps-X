terraform {
  backend "gcs" {
    bucket = "barberops-xx-tfstate"
    prefix = "dev"
  }
}