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

execute "untar-wordpress" do
	cwd "/var/www/"
	command "tar -xzf #{Chef::Config[:file_cache_path]}/wordpress-3.8.1.tar.gz"
	creates "/var/www/wordpress/wp-settings.php"
end

include_recipe "mysql::default"
Gem.clear_paths
require 'mysql'

execute "create wordpressdb database" do
    command "/usr/bin/mysqladmin --user=root --password=rootpass create wordpressdb"
    not_if do
      m = Mysql.new("localhost", "root", "rootpass")
      m.list_dbs.include?("wordpressdb")
    end
end

execute "mysql-install-privileges" do
    command "/usr/bin/mysql --user=root --password=rootpass < /etc/mysql/grants.sql"
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

service "mysql" do
  action :restart
end

template "/var/www/wordpress/wp-config.php" do
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

web_app "wordpress" do
    template "wordpress.conf.erb"
    docroot "/var/www/wordpress"
    server_name server_fqdn
    server_aliases node.fqdn
end