# -*- mode: ruby -*-
# vi: set ft=ruby :

# Box metadata location and box name
BOX_URL = "https://oracle.github.io/vagrant-projects/boxes"
BOX_NAME = "oraclelinux/8"

Vagrant.configure("2") do |config|
  config.vm.box = BOX_NAME
  config.vm.box_url = "#{BOX_URL}/#{BOX_NAME}.json"


  # VM mysql
  config.vm.define "mysql" do |mysql|

    # HOSTNAME
    mysql.vm.hostname = "ol-mysql"

    # NETWORK
    mysql.vm.network "public_network" ,ip: "192.168.0.134"
    mysql.vm.network "forwarded_port", guest: 3306, host: 3306, adapter: 1 , guest_ip: "192.168.0.134" ,host_ip: "192.168.0.33"

    # MOUNTS
    mysql.vm.synced_folder ".", "/vagrant", disabled: true
    mysql.vm.synced_folder "./security", "/home/vagrant/security"

    # PROVIDER
    mysql.vm.provider "virtualbox" do |vb|
      vb.name = "ol-mysql"
      vb.memory = 2048
      vb.cpus = 1
    end

    # PROVISION
    # SSH,FIREWALLD AND SELINUX
    mysql.vm.provision "shell", inline: <<-SHELL
      cat /home/vagrant/security/id_rsa.pub >> .ssh/authorized_keys
      chmod 600 /home/vagrant/security/id_rsa
      chown vagrant:vagrant /home/vagrant/security/id_rsa
      sudo systemctl stop firewalld
      sudo systemctl disable firewalld
      sudo setenforce Permissive
      SHELL

    mysql.vm.provision "shell",inline: <<-SHELL
      # sudo yum update -y
      dnf install python3 -y
      SHELL
  end

  #VM wordpress
  config.vm.define "wordpress" do |wordpress|

    # HOSTNAME
    wordpress.vm.hostname = "ol-wordpress"

    # NETWORK
    wordpress.vm.network "public_network" ,ip: "192.168.0.135"
    wordpress.vm.network "forwarded_port", guest: 80, host: 8080, adapter: 1 , guest_ip: "192.168.0.135" ,host_ip: "192.168.0.33"

    # MOUNTS
    wordpress.vm.synced_folder ".", "/vagrant", disabled: true
    wordpress.vm.synced_folder "./security", "/home/vagrant/security"

    # PROVIDER
    wordpress.vm.provider "virtualbox" do |vb|
      vb.name = "ol-wordpress"
      vb.memory = 1024
      vb.cpus = 1
    end

    # PROVISION
    # SSH,FIREWALLD AND SELINUX
    wordpress.vm.provision "shell", inline: <<-SHELL
      cat /home/vagrant/security/id_rsa.pub >> .ssh/authorized_keys
      chmod 600 /home/vagrant/security/id_rsa
      chown vagrant:vagrant /home/vagrant/security/id_rsa
      sudo systemctl stop firewalld
      sudo systemctl disable firewalld
      sudo setenforce Permissive
      SHELL

    # INSTALL UPDATES AND TOOLS
    wordpress.vm.provision "shell",inline: <<-SHELL
      # sudo yum update -y
      dnf install python3 -y
      SHELL

    wordpress.vm.provision "ansible" do |ansible|
      ansible.limit = "all"
      ansible.inventory_path = "provisioning/hosts"
      ansible.playbook = "provisioning/site.yml"

    end

  end

end