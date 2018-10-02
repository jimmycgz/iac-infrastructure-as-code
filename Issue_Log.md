	# Issue Log
	
  ## Terraform doesn't keep the state for some resources, which only run one time at beging.
  Resolution: Suessfully done this via resource "null_resource" "rerun" and use uuid as trigger , find this section at the bottom of the .tf file. Use uuid as trigger so Terraform will run the non-state provisioner (like file, local-exec and remote-exec) in this group for each run.
  
  ## Can't bootstrap by neither remote-exec or run a .sh file in the new instance.
  Resolution: Used my own AMI with the API pre-configured, then user Terraform remote-exec to update the ip address of API3-GCP into the Json config file of API1-AWS.
  
  ## How to add a quate (") to a txt file by echo in Terraform? like  command="echo "IP_add=": >IP.txt",
  Resolution: use the combination of (\") and (') like command="echo ' \"IP_add=\":' >IP.txt". Can also pupolate the content by Terraform local_file with EOF sign.
  
  ## Can't associate one IGW to multiple subnets, Terraform seems only associate it to the last one in resource IGW_asso
  Resolution: use count to associate every subnet to IGW.
  
  ## Meet error like: "error 12: out of memory" when running Ansible
  Resolution: Restart the tool server and try again. 
