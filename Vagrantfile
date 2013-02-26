Vagrant::Config.run do  | config |
    config.vm.box = "precise32"
    config.vm.box_url = "http://files.vagrantup.com/precise32.box"

    config.vm.customize ["modifyvm", :id, "--memory", "512"]    

    config.vm.network :hostonly, "192.168.33.10"
    config.vm.share_folder "webroot" , "/home/vagrant/webroot", "./webroot/", :nfs => true 
 
    config.vm.provision :chef_solo do |chef|
        chef.cookbooks_path = ["cookbooks"]
        chef.add_recipe "apt"
        chef.add_recipe "build-essential"
        chef.add_recipe "git"
        chef.add_recipe "app"
        chef.add_recipe "php"
        chef.add_recipe "php::module_apc"
        chef.add_recipe "php::module_curl"
        chef.add_recipe "php::module_gd"
        chef.add_recipe "php::module_mysql"     
        chef.add_recipe "chef-php-extra::development"
        chef.add_recipe "composer"
        chef.add_recipe "php-fpm"
        chef.add_recipe "vim"
        
        chef.json = {
            :app => {
                :name           => "blog",
                :db_user        => "blog",
                :db_pass        => "blog",
                :db_name        => "blog",
                :dbserver_type  => "mysql",
                :webserver_type => "apache",
                :server_name    => "blog.dev",
                :docroot        => "/home/vagrant/webroot/blog/public",
            },
            :mysql => { 
                :server_root_password   => "password",
                :server_debian_password => "password",
                :server_repl_password   => "password",
                :bind_address           => "192.168.33.10",
                :allow_remote_root      => true
            }
        }
    end
end
