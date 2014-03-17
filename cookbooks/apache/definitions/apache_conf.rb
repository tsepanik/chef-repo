define :apache_conf do
  template "/etc/apache2/mods-available/#{params[:name]}.conf" do
    source   "mods/#{params[:name]}.conf.erb"
    mode     '0644'
    notifies :restart, 'service[apache2]'
  end
end