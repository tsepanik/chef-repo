#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#Install apache
package "apache2" do 
	action :install
end

#Start and enable apache
service "apache2" do
	action [ :enable, :start ]
end

#create basic display
cookbook_file "/var/www/index.html" do
	source "index.html"
	mode "0644"
end