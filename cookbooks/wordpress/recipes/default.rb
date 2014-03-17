#
# Cookbook Name:: wordpress
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

remote_file "#{Chef::Config[:file_cache_path]}/wordpress-3.8.1.tar.gz" do 
	source "http://wordpress.org/wordpress-3.8.1.tar.gz"
	mode "0644"
end

directory "/var/www/wordpress" do
	owner "root"
	group "root"
	mode "0755"
	action :create
end

execute "expand-wordpress" do
	cwd "/var/www/wordpress"
	command "tar -xzf #{Chef::Config[:file_cache_path]}/wordpress-3.8.1.tar.gz"
	creates "/var/www/wordpress/wp-settings.php"
end

execute "create wordpressdb database" do
    command "/usr/bin/mysqladmin -u root -p#{node[:mysql][:server_root_password]} create wordpressdb"
    not_if do
      m = Mysql.new("localhost", "root", @node[:mysql][:server_root_password])
      m.list_dbs.include?(wordpressdb)
    end
end

execute "mysql-install-privileges" do
    command "/usr/bin/mysql -u root -p 'rootpass' < /etc/mysql/grants.sql"
    action :nothing
end

template "/etc/mysql/grants.sql" do
    source "grants.sql.erb"
    owner "root"
    group "root"
    mode "0600"
    variables(
      :user     => "wordpressuser",
      :password => "wordpress",
      :database => "wordpressdb"
    )
    notifies :run, resources(:execute => "mysql-install-privileges"), :immediately
end

template "/var/www//wordpress/wp-config.php" do
    source "wp-config.php.erb"
    owner "root"
    group "root"
    mode "0644"
    variables(
      :database        => "wordpressdb",
      :user            => "wordpressuser",
      :password        => "wordpress"
    )
end

#include_recipe "apache::web_app"

web_app "wordpress" do
    template "wordpress.conf.erb"
    docroot "/var/www/wordpress"
    server_name server_fqdn
    server_aliases node.fqdn
end