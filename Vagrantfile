# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.network "private_network", ip: "192.168.56.100"

  config.vm.cloud_init :user_data do |cloud_init|
    cloud_init.content_type = "text/cloud-config"
    cloud_init.path = "cloud-init/config.yml"
  end
end
