# See http://docs.opscode.com/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "tsepanik1"
client_key               "#{current_dir}/tsepanik1.pem"
validation_client_name   "novatest3-validator"
validation_key           "#{current_dir}/novatest3-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/novatest3"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]
