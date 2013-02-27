app_name = "#{node['app']['name']}"

web_app app_name do 
    server_name node['app']['server_name']
    server_aliases node['app']['server_aliases']
    docroot node['app']['docroot']
    template "apache.conf.erb" 
    log_dir node['apache']['log_dir'] 
end

apache_site "000-default" do
  enable false
end