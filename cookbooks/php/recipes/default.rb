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

include_recipe "php::libapache2-mod-php5.rb"
include_recipe "php::php5-mcrypt"
include_recipe "php::php5-mysql"

service "apache2" do
	action :restart
end

