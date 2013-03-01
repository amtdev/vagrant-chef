# Set up Database
# Create app database
ruby_block "create_#{node['app']['name']}_db" do
    block do
        %x[mysql -uroot -p#{node['mysql']['server_root_password']} -e "CREATE DATABASE #{node['app']['db_name']};"]
    end 
    not_if "mysql -uroot -p#{node['mysql']['server_root_password']} -e \"SHOW DATABASES LIKE '#{node['app']['db_name']}'\" | grep #{node['app']['db_name']}";
    action :create
end

# Grant mysql privileges for web user 
ruby_block "add_localhost_#{node['app']['name']}_permissions" do
    block do
        %x[mysql -u root -p#{node['mysql']['server_root_password']} -e "GRANT ALL \
          ON #{node['app']['db_name']}.* TO '#{node['app']['db_user']}'@'localhost' IDENTIFIED BY '#{node['app']['db_pass']}';"]
    end
    not_if "mysql -u root -p#{node['mysql']['server_root_password']} -e \"SELECT user, host FROM mysql.user\" | \
        grep #{node['app']['db_user']} | grep localhost"
    action :create
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