execute "restart postgres" do
    command "sudo /etc/init.d/postgresql restart"
end

execute "create-database" do
    command "createdb -U postgres -O postgres #{node['app']['db_name']}"
end

execute "create-user" do
    command "create user #{node['app']['db_user']} with password '#{node['app']['db_pass']}';"
end

execute "grant options" do
    command "grant all privileges on database #{node['app']['db_name']} to #{node['app']['db_user']};"
end