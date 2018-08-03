# Infrastructure as Code  -my collections
Repo for all infrastructure related code for build and configuration
* For continuous delivery pipeline configuration as code
* For CICD template code and version control

# Linux Script for Configuration Management
for host in $(cat hosts.txt); do ssh "$host" "sudo reboot"; done

#!/usr/bin/env bash
#Deploy to all pinable Product Web Instance(s) Ubuntu .
#AWS subnet1 and subnet2 10.0.1.x 10.0.2.x
#GCP subnet 
#Azure subnet

# Generate a hosts.txt file collecting all pinable IP in one Prod subnet
echo "Generating a hosts.txt file collecting all pinable IPs in one Subnet"
seq 254 | xargs -iIP -P255 ping -c1 10.0.1.IP |gawk -F'[ :]' '/time=/{print $4}'  >hosts.txt
seq 254 | xargs -iIP -P255 ping -c1 10.0.2.IP |gawk -F'[ :]' '/time=/{print $4}'  >>hosts.txt

echo "Run Deploy script file in a loop for all pinable instances"

# Push Deployment: Run Deploy script file in a loop
#Ansible-playbook mybook.yml –syntax-check 
for host in $(cat hosts.txt); do sudo ssh -i /home/ubuntu/.ssh/My_2018.pem ubuntu@$host "sh /home/ubuntu/Deploy_Prod.sh"; done  |true


# Ansible Script for Pull Deployment
ansible gcp_web_prod -a "sudo reboot"
Reboot each instance via ansible playbook to auto deploy by this script. All instances are pre-configured startup script to pull the latest release code from a registry say AWS S3 bucket or ECR. Such startup script can be configured in Linux CLI: crontab –e 

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
  content '<h1>Hello, world!</h1>'
end

service 'httpd' do
  action [:start, :enable]
end

