#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "mysql::client"

  directory "/var/cache/local/preseeding" do
    owner "root"
    group "root"
    mode 0755
    recursive true
  end
  
  execute "preseed mysql-server" do
    command "debconf-set-selections /var/cache/local/preseeding/mysql-server.seed"
    action :nothing
  end

  template "/var/cache/local/preseeding/mysql-server.seed" do
    source "mysql-server.seed.erb"
    owner "root"
    group "root"
    mode "0600"
    notifies :run, resources(:execute => "preseed mysql-server"), :immediately
  end

package "mysql-server" do
	action :install
end

service "mysql" do
	service_name "mysql"
	supports :status => true, :restart => true, :reload => true
	action :enable
end

package "libapache2-mod-auth-mysql" do
	action :install
end

include_recipe "php::php5-mysql"

service "mysql" do
	action :restart
end