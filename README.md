# Infrastructure as Code  
## My Collections using Terraform, Ansible, Chef and Linux scripting


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
  
   ** Step 4.1> [DONE! Sep26] Manually installed httpd web service in API2GCP on GCP and connect it with API1-AWS on AWS Tool Server: http://35.231.144.74:5000/  manually added this ip to the config.json in API1-AWS (AWS Subnet1) so they both are connected.
   
   ** Step 4.2> [DONE! Sep28] User Terraform Remote-exec to automaticaly update the ip address of API3-GCP into the config.json in API1-AWS (AWS Subnet1) 
   
   Suessfully done this via resource "null_resource" "rerun" and use uuid as trigger , find this section at the bottom of the .tf file
   
 Use uuid as trigger so Terraform will run the non-state provisioner (like file, local-exec and remote-exec) in this group for each run
  
  Issue found: remote-exec creates file on the terraform host if I run it in instance resource or eip resource
  
  Resolution: run it in "null_resource" and use uuid as trigger.
  
  Issue found: can't bootstrap by neither remote-exec or run a .sh file in the new instance.
  
  Resolution: Step 4.3> [DONE!] Use my own AMI with the API pre-configured, then user Terraform remote-exec to update the ip address of API3-GCP into the Json config file of API1-AWS.
  
  Issue found: how to add a quate (") to a txt file by echo in Terraform? like  command="echo "IP_add=": >IP.txt",
  Resolution: use the combination of (\") and (') like command="echo ' \"IP_add=\":' >IP.txt",
  
  Issue found: Can't associate one IGW to multiple subnets, Terraform seems only associate it to the last one in resource IGW_asso
  
  ** Step [WIP] 4.4 Rename API2 (GCP) to API3-GCP, correc the display name in API-AWS code.
    Sep 29th: have created 3 folders in Repo API-DEMO, just need to futher tailor the code accordingly. And then try ansible as Step 4.5 after resolving the above issue to associate IGW to Subnet 2.
  
  
  ** Step 4.5> [WIP] Use ansible to deploy API web service for API1-AWS, API2-AWS and connect to API3-GCP.
  
  * Further Step > [To Do] try use Terraform template .tpl to update the ip into the config file. or use File provisioner.
  
  
  * Step 5> [To Do] Run Chef local mode through Terraform
  
  Need to figure out how to use Chef client mode to manage a new node created by Terraform
    
  https://github.com/mjuuso/provisioning_example/blob/master/resources.tf
  
  * Step 6> [To Do]Deploy to Docker by Terraform
 
  https://github.com/hashicorp/docker-hub-images/tree/master/terraform
  
   * Step 7> [To Do]Deploy to Azure container by Terraform
   https://github.com/OSSCanada/portal-and-cloudshell/blob/master/main.tf
   
  
# Ansible Script for Pull Deployment
    *ansible gcp_web_prod -a "sudo reboot"

Reboot each instance via ansible playbook to auto deploy by this script. All instances are pre-configured startup script to pull the latest release code from a registry say AWS S3 bucket or ECR. Such startup script can be configured in Linux CLI: 

crontab –e 

/# Restart the tool server if you meet error like: "error 12: out of memory".
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


