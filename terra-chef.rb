package 'httpd'
file '/var/www/html/index.html' do
  content "<BR> <h2> Hello World V1 made by Chef through Terraform. </h2>
  <BR>
  <h2> IP Address:  #{node['ipaddress']} </h2>
  <h2> HostName: #{node['hostname']} </h2>
  "
end
  
service 'httpd' do
  action [:start, :enable]
end

  
    
