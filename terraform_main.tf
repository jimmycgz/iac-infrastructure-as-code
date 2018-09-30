provider "aws" {
  shared_credentials_file = "/home/ubuntu/.aws/credentials"
  profile                 = "default"
  
  region = "ca-central-1"
}

variable "vpc_cidr" {
  default="172.17.0.0/16"
  }

variable "subnet_cidrs_public" {
  # https://www.terraform.io/docs/configuration/interpolation.html#cidrsubnet-iprange-newbits-netnum-
  default = ["172.17.0.0/24", "172.17.1.0/24"]
  type = "list"
  
  }

resource "aws_vpc" "j_t_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name = "J_T_VPC"
  }
}

resource "aws_subnet" "j_t_pub_subnet" {
  count="${length(var.subnet_cidrs_public)}"
  
  vpc_id     = "${aws_vpc.j_t_vpc.id}"
  cidr_block = "${var.subnet_cidrs_public[count.index]}"

  tags {
    Name = "J_T_VPC_Sub"
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
  count="${length(var.subnet_cidrs_public)}"
  
  subnet_id ="${element(aws_subnet.j_t_pub_subnet.*.id, count.index)}"
#  subnet_id ="${aws_subnet.j_t_subnet1.id}"
  route_table_id="${aws_route_table.j_t_public_rt_table.id}"
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


resource "aws_instance" "j_t_API-AWS" {
  count="${length(var.subnet_cidrs_public)}"
  
  #ami                    = "ami-0d12bbc5df9d0d8c8"
  ami                    = "ami-9526abf1"

  instance_type          = "t2.micro"
  key_name               = "Jmy_Key_AWS_Apr_2018"
  vpc_security_group_ids = ["${aws_security_group.j_t_sg_demo1.id}"]
  
  subnet_id ="${element(aws_subnet.j_t_pub_subnet.*.id, count.index)}"
  #subnet_id              = "${aws_subnet.j_t_subnet1.id}"
  
  tags = {
    Name = "J_T_API1-AWS"
  }
}

resource "aws_eip" "j_t_eip" {
  count="${length(var.subnet_cidrs_public)}"
  
  vpc      = true

  tags {
    Name = "J_T_Eip1"
  }
}

resource "aws_eip_association" "j_t_eip_asso" {
  count="${length(var.subnet_cidrs_public)}"
  
  instance_id="${element(aws_instance.j_t_API-AWS.*.id, count.index)}"
  allocation_id ="${element(aws_eip.j_t_eip.*.id, count.index)}"
 
  # EIP1 association
 } 

