define :web_app, :template => 'web_app.conf.erb', :enable => true do

  application_name = params[:name]

  include_recipe 'apache::default'
  include_recipe 'apache::mod_rewrite'
  include_recipe 'apache::mod_deflate'
  include_recipe 'apache::mod_headers'

  template "/etc/apache2/sites-available/#{application_name}.conf" do
    source   params[:template]
    owner    'root'
    group    'root'
    mode     '0644'
    cookbook params[:cookbook] if params[:cookbook]
    variables(
      :application_name => application_name,
      :params           => params
    )
    if ::File.exists?("/etc/apache2/sites-enabled/#{application_name}.conf")
      notifies :reload, 'service[apache2]'
    end
  end

  site_enabled = params[:enable]
  apache_site "#{params[:name]}.conf" do
    enable site_enabled
  end
end
