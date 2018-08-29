terraform {
  backend "s3" {
    bucket = "terra-jmy-bucket"
    key    = "mystate"
    region = "ca-central-1"
  }
}
