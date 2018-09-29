provider "aws" {
  shared_credentials_file = "/home/ubuntu/.aws/credentials"
  profile                 = "default"
  
  region = "ca-central-1"
}

resource "aws_vpc" "j_t_vpc" {
  cidr_block           = "172.17.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name = "J_T_VPC"
  }
}

resource "aws_subnet" "j_t_subnet1" {
  vpc_id     = "${aws_vpc.j_t_vpc.id}"
  cidr_block = "172.17.0.0/24"

  tags {
    Name = "J_T_VPC_Sub1"
  }
}

resource "aws_subnet" "j_t_subnet2" {
  vpc_id     = "${aws_vpc.j_t_vpc.id}"
  cidr_block = "172.17.1.0/24"

  tags {
    Name = "J_T_VPC_Sub2"
  }
}

resource "aws_security_group" "j_t_sg_demo1" {
  name        = "j_t_sg-demo1"
  description = "Security Group in Subnet1: allow 80/22/3000 inbound traffic and all outbound"
  vpc_id      = "${aws_vpc.j_t_vpc.id}"
  
    # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
    # HTTP access from anywhere
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  
    # HTTP access from anywhere
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

resource "aws_internet_gateway" "j_t_igw" {
  vpc_id="${aws_vpc.j_t_vpc.id}"

  tags {
   Name="J_T_VPC_IGW"
  }

}

resource "aws_route_table" "j_t_public_rt_table" {
vpc_id="${aws_vpc.j_t_vpc.id}"

route {
  cidr_block ="0.0.0.0/0"
  gateway_id="${aws_internet_gateway.j_t_igw.id}"
}

  tags {  Lable="J_T_RT"}

}


resource "aws_route_table_association" "j_t_rt_asso" {
  subnet_id ="${aws_subnet.j_t_subnet2.id}"
  subnet_id ="${aws_subnet.j_t_subnet1.id}"
  route_table_id="${aws_route_table.j_t_public_rt_table.id}"
}

resource "aws_instance" "j_t_API1-AWS" {
  # ami                    = "ami-0d12bbc5df9d0d8c8"
  ami                    = "ami-9526abf1"
  instance_type          = "t2.micro"
  key_name               = "Jmy_Key_AWS_Apr_2018"
  vpc_security_group_ids = ["${aws_security_group.j_t_sg_demo1.id}"]
  subnet_id              = "${aws_subnet.j_t_subnet1.id}"
  

  

  tags = {
    Name = "J_T_API1-AWS"
  }
}

resource "aws_eip" "j_t_eip1" {
  vpc      = true

  tags {
    Name = "J_T_Eip1"
  }
}

resource "aws_eip_association" "j_t_eip1_asso" {
  instance_id="${aws_instance.j_t_API1-AWS.id}"
  allocation_id ="${aws_eip.j_t_eip1.id}"
  


  
  # EIP1 association
 } 


resource "aws_instance" "j_t_API2-AWS" {
  ami                    = "ami-9526abf1"
  instance_type          = "t2.micro"
  key_name               = "Jmy_Key_AWS_Apr_2018"
  vpc_security_group_ids = ["${aws_security_group.j_t_sg_demo1.id}"]
  subnet_id              = "${aws_subnet.j_t_subnet2.id}"

  tags = {
    Name = "J_T_API2-AWS"
  }
  
}

resource "aws_eip" "j_t_eip2" {
  vpc      = true

  tags {
    Name = "J_T_Eip2"
  }
}

resource "aws_eip_association" "j_t_eip2_asso" {
  instance_id="${aws_instance.j_t_API2-AWS.id}"
  allocation_id ="${aws_eip.j_t_eip2.id}"
}


resource "null_resource" "rerun" {
# Use uuid as trigger so Terraform will run the non-state provisioner (like file, local-exec and remote-exec) in this group for each run
  # By default, Terraform only run these non-state provisioners once if you excute apply based on already-built resource, unless you run the apply after each destroy.
  
  
  triggers {
    rerun= "${uuid()}"
  }

    # Add the new public ip (EIP1 and EIP2) to local config file
  provisioner "local-exec" {
    command = "echo ${aws_eip.j_t_eip1.public_ip} >/home/ubuntu/host-ip-local.txt"

  }
  
  provisioner "local-exec" {
    command = "echo ${aws_eip.j_t_eip2.public_ip} >>/home/ubuntu/host-ip-local.txt"
 #   command = "ansible-playbook -i /usr/local/bin/terraform-inventory -u ubuntu playbook.yml --private-key=/home/user/.ssh/aws_user.pem -u ubuntu"
 
  }
    
  
  provisioner "local-exec" {
  #command = "ansible-playbook -i /usr/local/bin/terraform-inventory -u ubuntu playbook.yml --private-key=/home/user/.ssh/aws_user.pem -u ubuntu"
  command=" echo to be test ansible "  
  }
  
 # Run remote provisioner on the instance after association of EIP to Instance1 and 2 on AWS.
    
  # Add the ip of API2-GCP to API1-AWS config file
      connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("/home/ubuntu/.ssh/Jmy_Key_AWS_Apr_2018.pem")}"
    #private_key = "${file("${path.module}/keys/terraform")}"
    host="${aws_eip.j_t_eip1.public_ip}"
  }
  
  provisioner "remote-exec" {
    # Update the ip address of API3-GCP to the config file on API1-AWS (AWS Subnet1)
      inline = [
      "echo { >/home/ubuntu/terraform/proj1/terraform-challenge/run-your-own-dojo/apis/api-1/config/config.json",
      "echo  '  \"api2_url\":\" http://35.231.144.74:5000\"' >>/home/ubuntu/terraform/proj1/terraform-challenge/run-your-own-dojo/apis/api-1/config/config.json",
      "echo } >>/home/ubuntu/terraform/proj1/terraform-challenge/run-your-own-dojo/apis/api-1/config/config.json",
     ]
  }
  
  # Bootstrape API2-AWS from a bare new AWS ami
  # Add the ip of API3-GCP to API2-AWS config file
      connection {
    type = "ssh"
    user = "ubuntu"
    private_key = "${file("/home/ubuntu/.ssh/Jmy_Key_AWS_Apr_2018.pem")}"
    #private_key = "${file("${path.module}/keys/terraform")}"
    host="${aws_eip.j_t_eip2.public_ip}"
  }
  
  provisioner "remote-exec" {
    # Update the ip address of API3-GCP to the config file on API1 (AWS Subnet1)
      inline = [
        
        "git clone https://github.com/slalomdojo/terraform-challenge"
        "curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -; sudo apt-get install -y nodejs"
        "cd terraform-challenge/run-your-own-dojo/apis/api-1"
        "npm install"
        "sudo npm install -g forever"
        "curl localhost:3000/health"
        "crontab -l > cron-tmp"
        "echo '\"@reboot forever start --watch --watchDirectory /home/ubuntu/terraform-challenge/run-your-own-dojo/apis/api-1/config/ /home/ubuntu/terraform-challenge/run-your-own-dojo/apis/api-1/index.js\"' >> cron-tmp"
        "crontab cron-tmp"
        
      "echo { >/home/ubuntu/terraform-challenge/run-your-own-dojo/apis/api-1/config/config.json",
      "echo  '\"api2_url\": \"http://35.231.144.74:5000\"' >>/home/ubuntu/terraform-challenge/run-your-own-dojo/apis/api-1/config/config.json",
      "echo } >>/home/ubuntu/terraform-challenge/run-your-own-dojo/apis/api-1/config/config.json",
     ]
  }
  
  #resource "null_resource" "uuid-trigger
}


