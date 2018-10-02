# Infrastructure as Code  
My Collections using Terraform, Ansible, Chef and Linux scripting


# Use Terraform to setup API workload infra in AWS:


 ## Details to set up:

* A VPC
* Two subnets
* An internet gateway
* A security group
* Using existing SSH key pair
* Two EC2 instances, API1-AWS on Subnet1, API2-AWS on Subnet2
* Within the instance:
   Sample API code written by Node.JS

## Setup Steps:
  * Step 1> [DONE!] create 1 VPC, 2 subnets and Security Group
  
  Refer to Repo:https://github.com/jimmycgz/Tarraform-Slalom-Dojo
  
  More learned from Microsoft Open Source Virutal Conference:
  
  https://github.com/hashicorp/microsoft-oss-conference
  
  https://www.hashicorp.com/resources/hangout-terraform-azure-for-beginners

  Refer to this webpage for Route table and IGW: https://040code.github.io/2017/06/18/terraform-aws-vpc/

  
  * Step 2> [DONE!]provision 2 VMs, API1-AWS using my own AMI with pre-configured API workload, API2-AWS use AWS AMI need further setup workload using Apache httpd.
  
  * Step 3> [DONE!]Run Terraform via Jenkins Pipeline

  https://github.com/david-wells-1/jenkins-terraform-pipeline
  
  * Step 4> [WIP] Deploy API2-AWS and API3-GCP instance and connect with API1-AWS
  
   ** Step 4.1> [DONE! Sep28] Manually installed httpd web service in API3GCP on GCP and connect it with API-AWS-Tool on AWS Tool Server. Used Terraform Remote-exec to automaticaly update the ip address of API3-GCP into the config.json in API-AWS-001 (AWS Subnet1) 
   

  ** Step 4.2 [DONE! Sep 30] Further refine Terraform code, use count, index, local_exec, local_file, remote_exec with SSH connection, AWS-ELB with multiple AZs (Detailed task items are listed in the top of Terraform.tf)
  
  ** Step 4.3 [WIP] Use Ansible for Configuration Management, the all public IPs are updated in a host file by Step 4.4
  
  ** Step [DONE! Oct 1st] 4.x Rename API2 (GCP) to API3-GCP, correc the display name in API-AWS code.
    Sep 29th: have created 3 folders in Repo API-DEMO, just need to futher tailor the code accordingly. And then try ansible as Step 4.5 after resolving the above issue to associate IGW to Subnet 2.
  
  
  ** Step 4.x> [WIP] Use ansible to deploy API web service for API1-AWS, API2-AWS and connect to API3-GCP.
  
  * Further Step > [To Do] try use Terraform template .tpl to update the ip into the config file. or use File provisioner.
  
  
  * Step 5> [To Do] Run Chef local mode through Terraform
  
  Need to figure out how to use Chef client mode to manage a new node created by Terraform
    
  https://github.com/mjuuso/provisioning_example/blob/master/resources.tf
  
  * Step 6> [To Do]Deploy to Docker by Terraform
 
  https://github.com/hashicorp/docker-hub-images/tree/master/terraform
  
   * Step 7> [To Do]Deploy to Azure container by Terraform
   https://github.com/OSSCanada/portal-and-cloudshell/blob/master/main.tf
   
  
 # Ansible Script for Configuration Management 
 
 ## Pull/Push Deployment
 
 Assume the file hosts has the updated host ip list from Terraform
  
     *sudo ansible-playbook ansible-web.yml --private-key=/home/ubuntu/.ssh/Jmy_Key_AWS_Apr_2018.pem
 
     *sudo ansible AWS -a "echo test" --private-key=/home/ubuntu/.ssh/Jmy_Key_AWS_Apr_2018.pem -u ubuntu

 Use -i specifies the ip host file, no need to use -u if already specified the login user name in yml
 
    *ansible-playbook -i /usr/local/bin/terraform-inventory playbook.yml --private-key=/home/user/.ssh/aws_user.pem -u ubuntu

    *ansible gcp_web_prod -a "sudo reboot"

Reboot each instance via ansible playbook to auto deploy by this script. All instances are pre-configured startup script to pull the latest release code from a registry say AWS S3 bucket or ECR. Such startup script can be configured in Linux CLI: 

crontab –e 


/# can also try to create a tag file using below ansible command and setup linux to check this file every 10mins, run deployment and delete this file. 

    *ansible gcp_web_prod -a "echo hello >/home/jimmycgz/deploy_start.txt"
    *ansible host -m shell -a 'echo hello && echo world'

    *sh $HOME/ansi_deploy.sh

# Chef Script
    *sudo chef-client --local-mode cookbooks/apache/recipes/server.rb

## Chef Recipe to build hello word web service

package 'httpd'

file '/var/www/html/index.html' do

  content 'Hello, world!'
  
end

service 'httpd' do

  action [:start, :enable]
  
end

# Linux Script for Configuration Management
    *for host in $(cat hosts.txt); do ssh "$host" "sudo reboot"; done

#!/usr/bin/env bash

#Deploy to all pinable Product Web Instance(s) Ubuntu .

#AWS subnet1 and subnet2 10.0.1.x 10.0.2.x

#GCP subnet 

#Azure subnet

#Generate a hosts.txt file collecting all pinable IP in one Prod subnet

    *echo "Generating a hosts.txt file collecting all pinable IPs in one Subnet"
note: all instances need to open ICMP port to be able to use ping.

    *seq 254 | xargs -iIP -P255 ping -c1 10.0.1.IP |gawk -F'[ :]' '/time=/{print $4}'  >hosts.txt

    *seq 254 | xargs -iIP -P255 ping -c1 10.0.2.IP |gawk -F'[ :]' '/time=/{print $4}'  >>hosts.txt

    *echo "Run Deploy script file in a loop for all pinable instances"


## Run Push script in Jenkins
    *for host in $(cat hosts.txt); do sudo ssh -i /home/ubuntu/.ssh/My_2018.pem ubuntu@$host "sh /home/ubuntu/Deploy_Prod.sh"; done  |true


