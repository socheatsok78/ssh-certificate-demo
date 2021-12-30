# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  (1..3).each do |i|
    config.vm.define "node-#{i}" do |node|
      node.vm.box = "ubuntu/focal64"
      node.vm.network "private_network", ip: "192.168.56.10#{i}"

      node.vm.cloud_init :user_data do |cloud_init|
        cloud_init.content_type = "text/cloud-config"
        cloud_init.path = "cloud-init/config.yml"
      end

      node.vm.provision "file",
        source: "./SignedHosts/node-#{i}-cert.pub",
        destination: "/tmp/trusted-host-rsa-cert.pub"

      $script = <<-SCRIPT
        sudo mv /tmp/trusted-host-rsa-cert.pub /etc/ssh/trusted-host-rsa-cert.pub
        sudo chmod 0400 /etc/ssh/trusted-host-rsa-cert.pub
      SCRIPT

      node.vm.provision "shell", reboot: true, inline: $script
    end
  end
end
