package "libmysqlclient15-dev" do
  action :install
end

package "mysql-client" do
  action :install
end

  r = gem_package "mysql" do
    action :nothing
  end

  r.run_action(:install)