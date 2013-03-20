# This recipe handles php configurations.  It will sort out the web server type, 
# and database server type.

# start it off...
app_name = "#{node['app']['name']}"
docroot = "#{node['app']['docroot']}"

# include default recipes
include_recipe "php"
include_recipe "chef-php-extra::development"
include_recipe "chef-php-extra::package"
include_recipe "composer"
include_recipe "phing"
include_recipe "php-fpm"

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
    
    # Initialize apache with correct template
    web_app app_name do 
        server_name node['app']['server_name']
        server_aliases node['app']['server_aliases']
        docroot node['app']['docroot']
        template "apache.php.conf.erb" 
        log_dir node['apache']['log_dir'] 
    end

    apache_site "000-default" do
      enable false
    end  
when 'nginx'
    # Set up Nginx virtual host
    include_recipe "nginx"

    # Initialize NGINX with correct template
    nginx_site "default" do
        enable false
    end

    template "#{node['nginx']['dir']}/sites-available/#{node['app']['name']}" do
        source "nginx.php.conf.erb"
        mode 644
    end

    nginx_site app_name do
        enable true
    end  
end