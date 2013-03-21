# This recipe handles django configurations.  It will sort out the web server type, 
# database server type, and then install django, and docutils.

# start it off...
app_name = "#{node['app']['name']}"
docroot = "#{node['app']['docroot']}"

# include default recipes
include_recipe "python"

# Check for db server type and proceed
case node['app']['dbserver_type']
when 'mysql'
    include_recipe "mysql::server"
    include_recipe "database::mysql"
    include_recipe "app::mysql"

    # install python-mysqldb
    package "python-mysqldb" do
        action :install
    end
when 'postgresql'
    include_recipe "postgresql::server"
    include_recipe "database::postgresql"
    include_recipe "app::postgresql"

    # install the psycopg2 library for postgresql
    package "python-psycopg2" do
        action :install
    end
when 'sqlite'
    include_recipe "php::module_sqlite3"
    include_recipe "sqlite"
end

# Check for webserver type and proceed
case node['app']['webserver_type']
when 'apache'
    # Set up the Apache virtual host 
    include_recipe "apache2" 
    include_recipe "apache2::mod_wsgi"
    include_recipe "apache2::mod_python"
    
    # Initialize apache with correct template
    web_app app_name do 
        server_name node['app']['server_name']
        server_aliases node['app']['server_aliases']
        docroot node['app']['docroot']
        template "apache.django.conf.erb" 
        log_dir node['apache']['log_dir'] 
    end

    apache_site "000-default" do
      enable false
    end

# When nginx is specified, install it and gunicorn together    
when 'nginx'
    # Set up Nginx virtual host
    include_recipe "nginx"

    # Initialize NGINX with correct template
    nginx_site "default" do
        enable false
    end

    template "#{node['nginx']['dir']}/sites-available/#{node['app']['name']}" do
        source "nginx.django.conf.erb"
        mode 644
    end

    nginx_site app_name do
        enable true
    end 
end

# install python-imaging
package "python-imaging" do
    action :install
end

# install docutils
python_pip "docutils" do
end

# install Django 1.5
python_pip "Django" do
  version "1.5"
end