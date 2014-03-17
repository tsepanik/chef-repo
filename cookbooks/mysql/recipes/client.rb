# package "mysql-client" do
# 	action :install
# end

# package "ruby-mysql" do
# 	action :install
# end

p = package "mysql-devel" do
  package_name value_for_platform(
    [ "centos", "redhat", "suse" ] => { "default" => "mysql-devel" },
    "default" => 'libmysqlclient15-dev'
  )
  action :nothing
end

p.run_action(:install)

package "mysql-client" do
  package_name value_for_platform(
    [ "centos", "redhat", "suse" ] => { "default" => "mysql" },
    "default" => "mysql-client"
  )
  action :install
end

case node[:platform]
when "centos","redhat", "suse"
  package "ruby-mysql" do
    action :install
  end

else
  r = gem_package "mysql" do
    action :nothing
  end

  r.run_action(:install)
end