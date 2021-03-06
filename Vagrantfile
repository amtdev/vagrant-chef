Vagrant::Config.run do  | config |
    config.vm.box = "precise32"
    config.vm.box_url = "http://files.vagrantup.com/precise32.box" 

    config.vm.network :hostonly, "192.168.33.10"
    config.vm.share_folder "webroot" , "/home/vagrant/webroot", "./webroot/", :nfs => true
 
    config.vm.provision :chef_solo do |chef|
        chef.cookbooks_path = ["cookbooks"]
        chef.add_recipe "apt"
        chef.add_recipe "build-essential"
        chef.add_recipe "git"
        chef.add_recipe "runit"
        chef.add_recipe "app::php"
        chef.add_recipe "vim"
        
        chef.json = {
            :app => {
                :name           => "wardrobe",
                :db_user        => "wardrobe",
                :db_pass        => "wardrobe",
                :db_name        => "wardrobe",
                :server_name    => "wardrobe.dev",
                :server_aliases => "*.wardrobe.dev",

                # Set docroot and working_dir. 
                # Docroot is where webserver points.  
                # Working dir is where entire project lives - might be the same, but could be one directory higher...
                :docroot        => "/home/vagrant/webroot/public",
                :working_dir    => "/home/vagrant/webroot",

                # Choose database type.  Choices are mysql, postgresql, sqlite, none
                :dbserver_type  => "mysql",

                # Choose webserver type.  Choices are nginx, apache
                :webserver_type => "apache",

                # Options for loading DB SQL file -- Only works for MySQL
                # Should we seed the database on first run?
                :db_load        => "false",
                
                # Filename for seed file.  Should be in the working directory
                :db_infile      => "seed.sql",

                # What table name should be used to verify that the seed db doesn't need to be applied.
                :db_table       => "some_table"
            },

            # If using MySQL, set defaults.
            :mysql => { 
                :server_root_password   => "password",
                :server_debian_password => "password",
                :server_repl_password   => "password",
                :bind_address           => "192.168.33.10",
                :allow_remote_root      => true
            },

            # If using PostgreSQL, set defaults
            :postgresql => {
                :password   => {
                    :postgres   => "password"
                },
                :pg_hba => [
                    {:type => 'local', :db => 'all', :user => 'postgres', :addr => nil, :method => 'md5'},
                    {:type => 'local', :db => 'all', :user => 'all', :addr => nil, :method => 'md5'},
                    {:type => 'host', :db => 'all', :user => 'all', :addr => '127.0.0.1/32', :method => 'md5'},
                    {:type => 'host', :db => 'all', :user => 'all', :addr => '::1/128', :method => 'md5'}
                ]
            },
            
            # List default PHP packages.  All others installed as dependencies in other packages
            :php => {
                :packages => [
                    "php5-cgi",
                    "php5",
                    "php5-dev",
                    "php5-cli",
                    "php-pear",
                    "php5-gd",
                    "php5-curl",
                    "php-apc",
                    "php5-xsl",
                    "libssh2-php"
                ]
            },
            
            # Ensure that build-essential runs 
            :build_essential => {
                :compiletime => true
            }
        }
    end
end
