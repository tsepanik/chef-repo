define :web_app, :template => 'web_app.conf.erb', :enable => true do

  application_name = params[:name]

  include_recipe 'apache2::default'
  include_recipe 'apache2::mod_rewrite'
  include_recipe 'apache2::mod_deflate'
  include_recipe 'apache2::mod_headers'

  template "#{node['apache']['dir']}/sites-available/#{application_name}.conf" do
    source   params[:template]
    owner    'root'
    group    node['apache']['root_group']
    mode     '0644'
    cookbook params[:cookbook] if params[:cookbook]
    variables(
      :application_name => application_name,
      :params           => params
    )
    if ::File.exists?("#{node['apache']['dir']}/sites-enabled/#{application_name}.conf")
      notifies :reload, 'service[apache2]'
    end
  end

  site_enabled = params[:enable]
  apache_site "#{params[:name]}.conf" do
    enable site_enabled
  end
end
