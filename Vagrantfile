# -*- mode: ruby -*-
# vi: set ft=ruby :

# Change this variable to the location of your testing public key if necessary.
ssh_pub_key = File.readlines("#{Dir.home}/.ssh/id_rsa.pub").first.strip

nodes = [
  { hostname:  "chosen",
    ip:        "192.168.56.20"
  },
  { hostname:  "vanillaqa1",
    ip:        "192.168.56.21"
  },
  { hostname:  "vanillaqa2",
    ip:        "192.168.56.22"
  },
  { hostname:  "holocron",
    ip:        "192.168.56.31"
  },
  { hostname:  "replicron1",
    ip:        "192.168.56.32"
  },
  { hostname:  "replicron2",
    ip:        "192.168.56.33"
  }
]

Vagrant.configure(2) do |config|
  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled = true
  end
  nodes.each do |node|
    config.vm.define node[:hostname] do |nodeconfig|
      nodeconfig.vm.box = "ubuntu/trusty64"
      nodeconfig.vm.hostname = node[:hostname]
      nodeconfig.vm.network :private_network, ip: node[:ip]
      nodeconfig.vm.synced_folder ".", "/vagrant", disabled: true
      nodeconfig.vm.provision :shell, inline: "echo #{ssh_pub_key} >> /root/.ssh/authorized_keys"
      nodeconfig.vm.provision :shell, inline: "echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys"
      nodeconfig.vm.provider :virtualbox do |v|
        v.name = node[:hostname]
        v.memory = 1024
      end
    end
  end
end
