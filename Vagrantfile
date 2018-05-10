# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
# set http_proxy=http://<mylogin>:<mypassword>@<myserver>:3128
# set https_proxy=%http_proxy%
# vagrant box add centos/7
# 
Vagrant.configure("2") do |config|
  # config.proxy.http     = "http://<mylogin>:<mypassword>@<myserver>:3128"
  # config.proxy.https    = "http://<mylogin>:<mypassword>@<myserver>:3128"
  # config.proxy.no_proxy = "localhost,127.0.0.1"
  puts "proxyconf..."
  if Vagrant.has_plugin?("vagrant-proxyconf")
    puts "find proxyconf plugin !"
    if ENV["http_proxy"]
      puts "http_proxy: " + ENV["http_proxy"]
      config.proxy.http = ENV["http_proxy"]
    end
    if ENV["https_proxy"]
      puts "https_proxy: " + ENV["https_proxy"]
      config.proxy.https = ENV["https_proxy"]
    end
    if ENV["no_proxy"]
      config.proxy.no_proxy = ENV["no_proxy"]
    end
  end

  config.vm.define "controller" do |subconfig|
    subconfig.vm.box = "centos/7"
    subconfig.vm.hostname = "wildfly.jobjects.org"
    subconfig.vm.synced_folder ".", "/vagrant", type: "virtualbox"
    subconfig.vm.boot_timeout = 240
    subconfig.vm.network :private_network, ip: "192.168.56.102"
    subconfig.vm.network "forwarded_port", guest: 5432, host: 5432, protocol: "tcp"
    subconfig.vm.network "forwarded_port", guest: 80, host: 80, protocol: "tcp"
    subconfig.vm.network "forwarded_port", guest: 8080, host: 8080, protocol: "tcp"
    subconfig.vm.network "forwarded_port", guest: 9990, host: 9990, protocol: "tcp"
    subconfig.vm.provider "virtualbox" do |vb|
      vb.cpus = 4
      vb.memory = "8192"
      vb.customize ['modifyvm', :id, '--cableconnected1', 'on']
    end
    subconfig.vm.provision "shell", inline: <<-SHELL1
      sudo sed -i -e "\\#PasswordAuthentication no# s#PasswordAuthentication no#PasswordAuthentication yes#g" /etc/ssh/sshd_config
      sudo chmod +x /vagrant/disable-ipv6.sh
      sudo /vagrant/disable-ipv6.sh
      sudo yum -y update
      sudo yum -y install epel-release
      sudo systemctl restart network
      sudo systemctl restart sshd
    SHELL1
    subconfig.vm.provision :ansible_local do |ansible|
      ansible.playbook       = "provision.yml"
      ansible.verbose        = true
      ansible.install        = true
      ansible.limit          = "all" # or only "nodes" group, etc.
      ansible.inventory_path = "inventory.txt"
    end    
  end
 
  puts "End"
end
