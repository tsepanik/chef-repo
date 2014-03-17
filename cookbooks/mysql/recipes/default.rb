#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "mysql::client"

package "libapache2-mod-auth-mysql" do
	action :install
end

package "php5-mysql" do
	action :install
end

package "mysql-server" do
	action :install
end

service "mysql" do
	service_name "mysql"
	supports :status => true, :restart => true, :reload => true
	action :enable
end

service "mysql" do
	action :restart
end