provider "aws" {
  region = "ca-central-1"
}

resource "aws_eip" "j_t_eip" {
  vpc      = true

  tags {
    Name = "J_T_Eip"
  }
}

resource "aws_eip_association" "j_t_eip_asso" {
  instance_id="${aws_instance.j_t_API1.id}"
  allocation_id ="${aws_eip.j_t_eip.id}"
}


resource "aws_internet_gateway" "j_t_igw" {
  vpc_id="${aws_vpc.j_t_vpc.id}"

  tags {
   Name="J_T_VPC_IGW"
  }

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

resource "aws_instance" "j_t_API1" {
  ami                    = "ami-01d6d481565727af1"
  instance_type          = "t2.micro"
  key_name               = "Jmy_Key_AWS_Apr_2018"
  vpc_security_group_ids = ["${aws_security_group.j_t_sg_allow_all.id}"]
  subnet_id              = "${aws_subnet.j_t_subnet1.id}"

  tags = {
    Name = "J_T_API1"
  }
}

resource "aws_security_group" "j_t_sg_allow_all" {
  name        = "j_t_sg-demo1"
  description = "Test SG in Subnet1: allow all inbound traffic"
  vpc_id      = "${aws_vpc.j_t_vpc.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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
  subnet_id ="${aws_subnet.j_t_subnet1.id}"
  route_table_id="${aws_route_table.j_t_public_rt_table.id}"
}



