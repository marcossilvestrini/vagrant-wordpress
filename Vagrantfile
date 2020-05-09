# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/8"
  config.vm.box_version = "1905.1"

  #VM mysql
  config.vm.define "mysql" do |mysql|

    # Monkey patch for https://github.com/dotless-de/vagrant-vbguest/issues/367
    class Foo < VagrantVbguest::Installers::CentOS
      def has_rel_repo?
        unless instance_variable_defined?(:@has_rel_repo)
          rel = release_version
          @has_rel_repo = communicate.test("yum repolist")
        end
        @has_rel_repo
      end

      def install_kernel_devel(opts=nil, &block)
        cmd = "yum update kernel -y"
        communicate.sudo(cmd, opts, &block)

        cmd = "yum install -y kernel-devel"
        communicate.sudo(cmd, opts, &block)

        cmd = "shutdown -r now"
        communicate.sudo(cmd, opts, &block)

        begin
          sleep 5
        end until @vm.communicate.ready?
      end
    end

    # INSTALL vbguest
    mysql.vbguest.installer = Foo

    # HOSTNAME
    mysql.vm.hostname = "centos8-mysql"

    # NETWORK
    mysql.vm.network "forwarded_port", guest: 3306, host: 3306
    mysql.vm.network "public_network" ,ip: "192.168.0.134"

    # MOUNTS
    mysql.vm.synced_folder ".", "/vagrant", disabled: true
    mysql.vm.synced_folder "./security", "/home/vagrant/security"

    # PROVIDER
    mysql.vm.provider "virtualbox" do |vb|
      vb.name = "centos8-mysql"
      vb.memory = 2048
      vb.cpus = 1
    end

    # PROVISION
    # SSH,FIREWALLD AND SELINUX
    mysql.vm.provision "shell", inline: <<-SHELL
      cat /home/vagrant/security/id_rsa.pub >> .ssh/authorized_keys
      sudo systemctl stop firewalld
      sudo systemctl disable firewalld
      sudo setenforce Permissive
      SHELL

    mysql.vm.provision "shell",inline: <<-SHELL
    #sudo yum update -y
    dnf install python3 -y
    SHELL

    mysql.vm.provision "ansible" do |ansible|
      ansible.playbook = "ansible/playbook-db.yml"
    end

  end

  #VM wordpress
  config.vm.define "wordpress" do |wordpress|

    # INSTALL vbguest
    wordpress.vbguest.installer = Foo

    # HOSTNAME
    wordpress.vm.hostname = "centos8-wordpress"

    # NETWORK
    wordpress.vm.network "forwarded_port", guest: 80, host: 8080
    wordpress.vm.network "public_network" ,ip: "192.168.0.135"

    # MOUNTS
    wordpress.vm.synced_folder ".", "/vagrant", disabled: true
    wordpress.vm.synced_folder "./security", "/home/vagrant/security"
    wordpress.vm.synced_folder "./configs", "/home/vagrant/configs"

    # PROVIDER
    wordpress.vm.provider "virtualbox" do |vb|
      vb.name = "centos8-wordpress"
      vb.memory = 1024
      vb.cpus = 1
    end

    # PROVISION
    # SSH,FIREWALLD AND SELINUX
    wordpress.vm.provision "shell", inline: <<-SHELL
      cat /home/vagrant/security/id_rsa.pub >> .ssh/authorized_keys
      sudo systemctl stop firewalld
      sudo systemctl disable firewalld
      sudo setenforce Permissive
      SHELL

    # INSTALL UPDATES AND TOOLS
    wordpress.vm.provision "shell",inline: <<-SHELL
    #sudo yum update -y
    dnf install python3 -y
    SHELL

     # INSTALL PACKAGES WITH ANSIBLE
    wordpress.vm.provision "ansible" do |ansible|
      ansible.playbook = "ansible/playbook-wordpress.yml"
    end

  end

end