provider "aws" {
  region = "ca-central-1"
}
 resource "aws_security_group" "jenkins-pipeline-sg" {
  name        = "jenkins-pipeline-sg"
  description = "built-by-jenkins-pipeline"
}
