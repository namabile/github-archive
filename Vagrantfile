# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.hostname = "harrys-bi-project"
  config.vm.box = "ubuntu_1204"
  config.vm.box_url = "https://s3-us-west-2.amazonaws.com/squishy.vagrant-boxes/precise64_squishy_2013-02-09.box"

  # config.vm.network :forwarded_port, guest: 3000, host: 3000
  config.vm.network :private_network, ip: "33.33.33.10"
  config.berkshelf.enabled = true

  config.vm.provision "chef_solo" do |chef|
    chef.add_recipe "omnibus_updater"
    chef.add_recipe "ubuntu"
    chef.add_recipe "nfs"
    chef.add_recipe "build-essential"
    chef.add_recipe "networking_basic"
    chef.add_recipe "ntp"
    chef.add_recipe "git"
    chef.add_recipe "openssl"
    chef.add_recipe "rsync"
    chef.add_recipe "rvm"
    chef.add_recipe "rvm::system"
    chef.add_recipe "rvm::vagrant"
  end

end
