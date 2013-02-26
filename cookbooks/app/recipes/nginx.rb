app_name = "#{node['app']['name']}"

nginx_site "default" do
    enable false
end

template "#{node['nginx']['dir']}/sites-available/#{node['app']['name']}" do
    source "nginx.conf.erb"
    mode 644
end

nginx_site app_name do
    enable true
end