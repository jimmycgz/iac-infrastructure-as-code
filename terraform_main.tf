# 1st try: Use count and index create 2 subnets in two AZs,  2 VMs on each subnet with associated public IPs.
# 2nd try: Extend the subnet cidr list from 2 to n, then create n VMs on each subnet with associated n eips. (line 18 in variable subnet_cidrs_public)
# More: Create ELB and distribute the traffic to those VMs.

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

resource "aws_vpc" "jt-vpc" {
  cidr_block           = "${var.vpc_cidr}"
  #instance_tenancy     = "default"
  #enable_dns_support   = true
 # enable_dns_hostnames = true

  tags {
    Name = "jt-vpc"
  }
}

# Create an internet gateway to give our subnets access to the outside world
resource "aws_internet_gateway" "jt-igw" {
  vpc_id="${aws_vpc.jt-vpc.id}"

  tags {   Name="jt-igw"  }

}

# Grant the VPC internet access on its main route table
resource "aws_route" "jt-rt_internet" {
  route_table_id="${aws_vpc.jt-vpc.main_route_table_id}"
  destination_cidr_block="0.0.0.0/0"
  gateway_id="${aws_internet_gateway.jt-igw.id}"
  
}

# Declare the data source
data "aws_availability_zones" "available" {}

resource "aws_subnet" "jt-pub_subnet" {
  count="${length(var.subnet_cidrs_public)}"
  
  vpc_id     = "${aws_vpc.jt-vpc.id}"
  cidr_block = "${var.subnet_cidrs_public[count.index]}"
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  map_public_ip_on_launch = true
  
  tags {
    #Name = "jt-vpc_subnet"
    Name = "${format("jt-vpc_subnet-%d", count.index + 1)}"
  }
  
}

# A security group for the ELB so it is accessible via the web
resource "aws_security_group" "jt-sg_elb" {
  name        = "jt-sg_elb"
  description = "Elb Used in the 2Tier DEMO"
  vpc_id      = "${aws_vpc.jt-vpc.id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Our default security group to access the instances over SSH and HTTP
resource "aws_security_group" "jt-sg_demo1" {
  name        = "jt-sg-demo1"
  description = "Security Group in Subnet1: allow 80/22/3000 inbound traffic and all outbound"
  vpc_id      = "${aws_vpc.jt-vpc.id}"
  
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

resource "aws_elb" "jt-elb" {
  name = "jt-demo-elb"

  subnets         = ["${aws_subnet.jt-pub_subnet.*.id}"]
  security_groups = ["${aws_security_group.jt-sg_elb.id}"]
  #availability_zones = ["${data.aws_availability_zones.available.names}"]
  instances       = ["${aws_instance.jt-api-aws.*.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}


resource "aws_instance" "jt-api-aws" {
  count="${length(var.subnet_cidrs_public)}"
  
  #ami                    = "ami-0d12bbc5df9d0d8c8"
  ami                    = "ami-9526abf1"

  instance_type          = "t2.micro"
  key_name               = "Jmy_Key_AWS_Apr_2018"
  vpc_security_group_ids = ["${aws_security_group.jt-sg_demo1.id}"]
  
  subnet_id ="${element(aws_subnet.jt-pub_subnet.*.id, count.index)}"
  #subnet_id              = "${aws_subnet.jt-subnet1.id}"
  
  tags = {
    #Name = "jt-api-aws"
    Name = "${format("jt-api-aws-%03d", count.index + 1)}"
  }
}

    # Add the all of new public ip (like the IPs of AWS-001 and AWS-002) to local config file
 resource "local_file" "inventory-ip-list" {
   filename="/home/ubuntu/host-ip-local.txt"
   
   content=<<-EOF
[AWS]
${join("\n",aws_instance.jt-api-aws.*.public_ip)}
  
[GCP]
   
EOF

  #End of local_file
  }


