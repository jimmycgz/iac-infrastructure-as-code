# Infrastructure as Code  -My Collections using Terraform, Ansible, Chef and Linux scripting

# Use Terraform to setup API workload infra in AWS:
Refer to Repo:https://github.com/jimmycgz/Tarraform-Slalom-Dojo

  Step 1> [DONE!] create 1 VPC, 2 subnets and Security Group
  Refer to this webpage for Route table and IGW: https://040code.github.io/2017/06/18/terraform-aws-vpc/
  
  Step 2> [DONE!]provision 2 VMs, API1 using my own AMI with pre-configured API workload, API2 use AWS AMI need further setup workload by Chef.
  
  Step 3> [DONE!]Run Terraform via Jenkins Pipeline
  https://github.com/david-wells-1/jenkins-terraform-pipeline
  
  Step 4> [To Do] Run Chef local mode through Terraform
  Need to figure out how to use Chef client mode to manage a new node created by Terraform
  https://github.com/mjuuso/provisioning_example/blob/master/resources.tf
  
  
  Step 5> [To Do]Deploy to Docker by Terraform
  https://github.com/hashicorp/docker-hub-images/tree/master/terraform
  
  
  
  
# Ansible Script for Pull Deployment
ansible gcp_web_prod -a "sudo reboot"

Reboot each instance via ansible playbook to auto deploy by this script. All instances are pre-configured startup script to pull the latest release code from a registry say AWS S3 bucket or ECR. Such startup script can be configured in Linux CLI: 

crontab –e 

/# Restart the tool server if you meet error like: "error 12: out of memory".
/# can also try to create a tag file using below ansible command and setup linux to check this file every 10mins, run deployment and delete this file. 
ansible gcp_web_prod -a "echo hello >/home/jimmycgz/deploy_start.txt"
ansible host -m shell -a 'echo hello && echo world'

sh $HOME/ansi_deploy.sh

# Chef Script
sudo chef-client --local-mode cookbooks/apache/recipes/server.rb

# Chef Recipe to build hello word web service

package 'httpd'

file '/var/www/html/index.html' do

  content 'Hello, world!'
  
end

service 'httpd' do

  action [:start, :enable]
  
end

# Linux Script for Configuration Management
for host in $(cat hosts.txt); do ssh "$host" "sudo reboot"; done

#!/usr/bin/env bash

#Deploy to all pinable Product Web Instance(s) Ubuntu .

#AWS subnet1 and subnet2 10.0.1.x 10.0.2.x

#GCP subnet 

#Azure subnet

#Generate a hosts.txt file collecting all pinable IP in one Prod subnet

echo "Generating a hosts.txt file collecting all pinable IPs in one Subnet"
note: all instances need to open ICMP port to be able to use ping.

seq 254 | xargs -iIP -P255 ping -c1 10.0.1.IP |gawk -F'[ :]' '/time=/{print $4}'  >hosts.txt

seq 254 | xargs -iIP -P255 ping -c1 10.0.2.IP |gawk -F'[ :]' '/time=/{print $4}'  >>hosts.txt

echo "Run Deploy script file in a loop for all pinable instances"


# Run Push script in Jenkins
for host in $(cat hosts.txt); do sudo ssh -i /home/ubuntu/.ssh/My_2018.pem ubuntu@$host "sh /home/ubuntu/Deploy_Prod.sh"; done  |true

# Push Deployment: Run Deploy script file in a loop
#Ansible-playbook mybook.yml –syntax-check 

