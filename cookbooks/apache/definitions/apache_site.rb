define :apache_site, :enable => true do
  include_recipe 'apache::default'

  if params[:enable]
    execute "a2ensite #{params[:name]}" do
      command "/usr/sbin/a2ensite #{params[:name]}"
      notifies :restart, 'service[apache2]'
      not_if do
        ::File.symlink?("/etc/apache2/sites-enabled/#{params[:name]}") ||
        ::File.symlink?("/etc/apache2/sites-enabled/000-#{params[:name]}")
      end
      only_if { ::File.exists?("/etc/apache2/sites-available/#{params[:name]}") }
    end
  else
    execute "a2dissite #{params[:name]}" do
      command "/usr/sbin/a2dissite #{params[:name]}"
      notifies :restart, 'service[apache2]'
      only_if do
        ::File.symlink?("/etc/apache2/sites-enabled/#{params[:name]}") ||
        ::File.symlink?("/etc/apache2/sites-enabled/000-#{params[:name]}")
      end
    end
  end
end