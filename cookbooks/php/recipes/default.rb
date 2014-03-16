#
# Cookbook Name:: php
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "php5-mysql" do
	action :install
end

package "php5-ldap" do
	action :install
end

package "php5" do
	action :install
end

service "apache2" do
	action :restart
end