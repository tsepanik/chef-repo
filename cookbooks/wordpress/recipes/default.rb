#
# Cookbook Name:: wordpress
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

remote_file "/tmp/wordpress-3.8.1.tar.gz" do 
	source "wordpress-3.8.1.tar.gz"
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
	command "tar -xzf /tmp/wordpress-3.8.1.tar.gz"
	creates "/var/www/wordpress/wp-settings.php"
end

execute "create wordpressdb database" do
    command "/usr/bin/mysqladmin -u root -p#{node[:mysql][:server_root_password]} create wordpressdb"
    not_if do
      m = Mysql.new("localhost", "root", "")
      m.list_dbs.include?(wordpressdb)
    end
end

execute "mysql-install-privileges" do
    command "/usr/bin/mysql -u root -p "" < /etc/mysql/grants.sql"
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

template "/var/www/wp-config.php" do
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
    docroot "/var/www"
    server_name( node.fqdn )
    server_aliases node.fqdn
end