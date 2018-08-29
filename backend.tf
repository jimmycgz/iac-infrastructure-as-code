terraform {
  backend "s3" {
    bucket = "terra-jmy-bucket"
    key    = "state"
    region = "ca-central-1"
  }
}
