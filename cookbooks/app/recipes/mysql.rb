# Set up Database
db_name = node['app']['db_name']
db_user = node['app']['db_user']
db_pass = node['app']['db_pass']

mysql_connection_info = {:host => "localhost",
                         :username => 'root',
                         :password => node['mysql']['server_root_password']}

# Create app database
mysql_database db_name do
  connection mysql_connection_info
  action :create
end

mysql_database_user db_user do
  connection mysql_connection_info
  password db_pass
  action :create
end

mysql_database_user db_user do
  connection mysql_connection_info
  password db_pass
  action :grant
end

# Load default database if desired, but only on first run
if node['app']['db_load'] == "true"
    ruby_block "seed #{node['app']['name']} database" do
        block do
            %x[mysql -u root -p#{node['mysql']['server_root_password']} #{node['app']['db_name']} < #{node['app']['working_dir']}/#{node['app']['db_infile']}]
        end
        not_if "mysql -u root -p#{node['mysql']['server_root_password']} -e \"SELECT 1 FROM #{node['app']['db_name']}.#{node['app']['db_table_name']}\" | \
            grep 1"
        action :create
    end
end