execute "restart postgres" do
    command "sudo /etc/init.d/postgresql restart"
end

bash "create database" do
  user 'postgres'
  code <<-EOH
echo "createdb -U postgres -O #{node['postgresql']['password']['postgres']} #{node['app']['db_name']};" | psql
  EOH
  action :run
end

bash "create user" do
  user 'postgres'
  code <<-EOH
echo "create user #{node['app']['db_user']} with password '#{node['app']['db_pass']}';" | psql
  EOH
  action :run
end

bash "grant permissions" do
  user 'postgres'
  code <<-EOH
echo "grant all privileges on database #{node['app']['db_name']} to #{node['app']['db_user']};" | psql
  EOH
  action :run
end