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