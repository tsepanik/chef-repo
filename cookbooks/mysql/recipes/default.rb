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

package "libapache2-mod-auth-mysql" do
	action :install
end

package "php5-mysql" do
	action :install
end

service "mysql" do
	service_name "mysql"
	supports :status => true, :restart => true, :reload => true
	action :enable
end

template "/etc/mysql/my.cnf" do
	source "my.cnf.erb"
	owner"root"
	group "root"
	mode "0644"
	notifies :restart, resources(:service => "mysql"), :immediately
end

service "mysql" do
	action :start
end