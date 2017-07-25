# -*- mode: ruby -*-
# vi: set ft=ruby :

# Change this variable to the location of your testing public key if necessary.
ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip

nodes = %w(
    chosen
    vanillaqa1
    vanillaqa2
    holocron
    replicron
    replicron1
    replicron2
)

Vagrant.configure(2) do |config|
  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
  else
    abort "Vagrant plugin vagrant-hostmanager"
  end

  nodes.each do |node|
    config.vm.define node[:hostname] do |nodeconfig|
      nodeconfig.vm.box = "ubuntu/trusty64"
      nodeconfig.vm.hostname = node
      nodeconfig.vm.network :private_network, type: "dhcp"
      nodeconfig.vm.synced_folder ".", "/vagrant", disabled: true
      nodeconfig.vm.provision :shell, inline: "echo #{ssh_pub_key} >> /root/.ssh/authorized_keys"
      nodeconfig.vm.provision :shell, inline: "echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys"
      nodeconfig.vm.provider :virtualbox do |v|
        v.name = node[:hostname]
        v.memory = 512
      end
    end
  end
end
