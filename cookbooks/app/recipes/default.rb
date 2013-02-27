# This recipe is the starter for all configuration.  It will sort out the web server type, 
# database server type, and desired framework.

# start it off...
app_name = "#{node['app']['name']}"
docroot = "#{node['app']['docroot']}"

# Check for db server type and proceed
case node['app']['dbserver_type']
when 'mysql'
    include_recipe "php::module_mysql"
    include_recipe "mysql::server"
    include_recipe "app::mysql"
when 'postgresql'
    include_recipe "php::module_pgsql"
    include_recipe "postgresql::server"
    include_recipe "app::postgresql"
when 'sqlite'
    include_recipe "php::module_sqlite3"
    include_recipe "sqlite"
end

# Check for webserver type and proceed
case node['app']['webserver_type']
when 'apache'
    # Set up the Apache virtual host 
    include_recipe "apache2"
    include_recipe "apache2::mod_php5"
    include_recipe "apache2::mod_rewrite" 
    include_recipe "app::apache"  
when 'nginx'
    # Set up Nginx virtual host
    include_recipe "nginx"
    include_recipe "app::nginx"  
end