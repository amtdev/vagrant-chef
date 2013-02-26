app_name = "#{node['app']['name']}"

web_app app_name do 
    server_name node['app']['server_name']
    docroot node['app']['docroot']
    template "apache.conf.erb" 
    log_dir node['apache']['log_dir'] 
end