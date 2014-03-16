#
# Cookbook Name:: php
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "php5" do
	action :install
end

package "libapache2-mod-php5" do
	action :install
end

package "php5-mcrypt" do
	action :install
end

package "php5-mysql" do
	action :install
end

cookbook_file "/var/www/index.php" do
	source "index.php"
	mode "0644"
end

service "apache2" do
	action :restart
end

