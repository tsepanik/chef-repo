define :apache_module, :enable => true, :conf => false do
  include_recipe 'apache::default'

  params[:filename]    = params[:filename] || "mod_#{params[:name]}.so"
  #params[:module_path] = params[:module_path] || "#{node['apache']['libexecdir']}/#{params[:filename]}"
  params[:identifier]  = params[:identifier] || "#{params[:name]}_module"

  apache_conf params[:name] if params[:conf]

  if params[:enable]
    execute "a2enmod #{params[:name]}" do
      command "/usr/sbin/a2enmod #{params[:name]}"
      notifies :restart, 'service[apache2]'
      not_if do
        ::File.symlink?("/etc/apache2/mods-enabled/#{params[:name]}.load") &&
        (::File.exists?("/etc/apache2/mods-available/#{params[:name]}.conf") ? ::File.symlink?("/etc/apache2/mods-enabled/#{params[:name]}.conf") : true)
      end
    end
  else
    execute "a2dismod #{params[:name]}" do
      command "/usr/sbin/a2dismod #{params[:name]}"
      notifies :restart, 'service[apache2]'
      only_if { ::File.symlink?("/etc/apache2/mods-enabled/#{params[:name]}.load") }
    end
  end
end
