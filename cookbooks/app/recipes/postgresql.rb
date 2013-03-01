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

# Load default database if desired, but only on first run
if node['app']['db_load'] == "true"
    ruby_block "seed #{node['app']['name']} database" do
        block do
            %x[psql -d #{node['app']['db_name']} -a -f #{node['app']['working_dir']}/#{node['app']['db_infile']}]
        end
        not_if "psql \"SELECT 1 FROM #{node['app']['db_name']}.#{node['app']['db_table_name']}\" | \
            grep 1"
        action :create
    end
end