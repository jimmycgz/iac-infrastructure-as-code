provider "aws" {
  
  access_key = "${var.aws_access_key_id}"
  secret_key = "${var.aws_secret_access_key}"
  region = "ca-central-1"
}
 resource "aws_security_group" "jenkins-pipeline-sg" {
  name        = "jenkins-pipeline-sg"
  description = "built-by-jenkins-pipeline"
}
