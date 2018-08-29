provider "aws" {
  
  shared_credentials_file = "/home/ubuntu/.aws/credentials"
  profile                 = "default"
  region = "ca-central-1"
}
 resource "aws_security_group" "jenkins-pipeline-sg" {
  name        = "jenkins-pipeline-sg"
  description = "built-by-jenkins-pipeline"
   
   vpc_id      = "vpc-6537bf0d"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
