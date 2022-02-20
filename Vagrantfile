# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box_check_update = true
  config.ssh.insert_key = true

  system("
    if [ #{ARGV[0]} = 'up' ]; then
        echo 'You are doing vagrant up and can execute your script'
        ./scripts/generate_key_gen.sh
    fi
  ")

  id_rsa_pub = File.read("./id_rsa.pub")
  id_rsa = File.read("./id_rsa")

  config.vm.define "ansible-server" do |ubuntu|
    ubuntu.vm.provider "virtualbox"
    ubuntu.vm.box = "ubuntu/focal64"
    ubuntu.vm.network "private_network", ip: "192.168.33.100"
    ubuntu.vm.hostname = "ansible-server"
    ubuntu.disksize.size = '80GB'

    ubuntu.vm.provider "virtualbox" do |u|
      u.name = "ansible-server"
      u.memory = "6000"
    end

    ubuntu.vm.provision "update", type: "shell",
      inline:
        "sudo apt-get -y update &&
        sudo apt-get -y upgrade &&
        sudo apt-get -y autoremove",
      run: "always"

    ubuntu.vm.provision "create archive id_rsa", type: "shell",
      inline: "touch /home/vagrant/.ssh/id_rsa"

    ubuntu.vm.provision "copy ssh key for vagrant user", type: "shell",
      inline: "echo \"#{id_rsa}\" >> /home/vagrant/.ssh/id_rsa"

    ubuntu.vm.provision "add permission id_rsa for vagrant user", type: "shell",
        inline: "chown vagrant /home/vagrant/.ssh/id_rsa && chmod 600 /home/vagrant/.ssh/id_rsa"
  end

  config.vm.define "ubuntu-1" do |ubuntu|
    ubuntu.vm.provider "virtualbox"
    ubuntu.vm.box = "ubuntu/focal64"
    ubuntu.vm.network "private_network", ip: "192.168.33.101"
    ubuntu.vm.hostname = "ubuntu-1"

    ubuntu.vm.provider "virtualbox" do |u|
      u.name = "ubuntu-1"
    end

    ubuntu.vm.provision "update", type: "shell",
      inline:
        "sudo apt-get -y update &&
        sudo apt-get -y upgrade &&
        sudo apt-get -y autoremove",
      run: "always"
  end

  config.vm.provision "create dir .ssh", type: "shell",
    inline: "sudo su && cd /root && mkdir -p .ssh && cd .ssh && touch authorized_keys"

  config.vm.provision "add permission .ssh/authorized_keys", type: "shell",
    inline: "sudo su && chmod 600 /root/.ssh/authorized_keys"

  config.vm.provision "copy ssh public key for vagrant user", type: "shell",
    inline: "echo \"#{id_rsa_pub}\" >> /home/vagrant/.ssh/authorized_keys"

  config.vm.provision "copy ssh public key for root user", type: "shell",
    inline: "echo \"#{id_rsa_pub}\" >> /root/.ssh/authorized_keys"
end
