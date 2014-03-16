#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "mysql-server" do
	action :install
end

service "mysql" do
	service_name "mysql"
	supports :status => true, :restart => true, :reload => true
	action :enable
end