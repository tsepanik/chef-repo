
Vagrant.configure("2") do |config|
  config.vm.network :forwarded_port, guest: 8080, host: 9090
  config.vm.box = "opscode-ubuntu-12.04-i386"
  config.vm.network :private_network, ip: "192.168.42.10"
  config.vm.hostname = "chefbox.vm"


# vagrant-omnibus plugin required to install chef
# run vagrant plugin install vagrant-omnibus on host to install
config.omnibus.chef_version = :latest

 config.vm.provision :chef_solo do |chef|
    chef.node_name = "Chefbox"
    chef.cookbooks_path = "cookbooks"
    chef.add_recipe "apt"
    chef.add_recipe "apache"
    chef.add_recipe "mysql"
    chef.add_recipe "php"
    chef.add_recipe "wordpress"
  end

end
