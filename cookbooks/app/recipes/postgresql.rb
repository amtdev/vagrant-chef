db_name = node['app']['db_name']
db_user = node['app']['db_user']
db_pass = node['app']['db_pass']

execute "restart postgres" do
    command "sudo /etc/init.d/postgresql restart"
end

postgresql_connection_info = {:host => "127.0.0.1",
                              :port => node['postgresql']['config']['port'],
                              :username => 'postgres',
                              :password => node['postgresql']['password']['postgres']}

postgresql_database db_name do
    connection postgresql_connection_info
    action :create
end

# create a postgresql user but grant no privileges
postgresql_database_user db_user do
    connection postgresql_connection_info
    password db_pass
    action :create
end

# grant all privileges on all tables in foo db
postgresql_database_user db_user do
    connection postgresql_connection_info
    database_name db_name
    privileges [:all]
    action :grant
end