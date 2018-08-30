terraform {
  backend "s3" {
    bucket = "terra-jmy-bucket"
    key    = "mystate"
    region = "ca-central-1"
    shared_credentials_file = "/home/ubuntu/.aws/credentials"
  profile                 = "default"
  }
}
