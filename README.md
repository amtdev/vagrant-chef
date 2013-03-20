Vagrant-Chef Development
============================
This is a work-in-progress.  My attempt is to have a single Vagrant-Chef instance that I can configure for whatever project I'm on.

This project was inspired by Gustavo Gama's [LEMP-Box for Vagrant](https://github.com/gustavobgama/LEMP-Box).

## Quick Start

First, make sure your development machine has [VirtualBox](http://www.virtualbox.org)
installed (version 4.2 and later are preferable). The setup from that point forward is very easy:

    1. Install Vagrant (version 1.0.5 and later are preferable)
    2. $ git clone --recursive https://github.com/davidstanley01/vagrant-chef.git your-folder
    3. cd your-folder
    4. Edit Vagrantfile with your specific settings (db_name, db_user, etc)
    5a.To choose a PHP project, include # app::php  
    5b.To choose a django project, include # app::django
    6. Add your code to the webroot directory as a submodule
    7. $ vagrant up
    8. Wait a few minutes   
    9. $ sudo su and then # echo "192.168.33.10  [app_name].dev" >> /etc/hosts


## Options

* PHP or Django/Python.  Django version is 1.5
* Apache2 or Nginx for webserver
* MySQL, PostgreSQL, or SQLite for database server

## To Do

There are a LOT of things to do.
* Allow user to specify PHP version to be installed, instead of just taking the default 5.3.10 version.
* Allow the user to specify django version
* Configure virtualenv options