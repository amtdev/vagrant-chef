# Run gunicorn and have it monitored by runit
# make the directory for the script to live in
execute "make the runit directory" do
    command "mkdir /etc/sv/#{node['app']['name']}/"
end

# Turn on the gunicorn process...we're web scale baby
gunicorn_config "/etc/gunicorn/#{node['app']['name']}.py" do
    worker_processes 3
    backlog 512
    action :create
end

# Create the template
gu_template = "/etc/sv/#{node['app']['name']}/run"
template gu_template do
    source "gunicorn.erb"
    mode 0660
    owner "root"
    group "root"
end

# Create the symbolic link so runit sees the file
bash "Make symbolic link" do
    user "root"
    code <<-EOH
ln -s /etc/sv/#{node['app']['name']} /etc/service/#{node['app']['name']}
    EOH
    action :run
end