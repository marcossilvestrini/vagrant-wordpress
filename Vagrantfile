# -*- mode: ruby -*-
# vi: set ft=ruby :

# https://github.com/dotless-de/vagrant-vbguest/issues/367
# https://github.com/dotless-de/vagrant-vbguest/pull/373

if defined?(VagrantVbguest)
  class MyWorkaroundInstallerUntilPR373IsMerged < VagrantVbguest::Installers::CentOS
    protected

    def has_rel_repo?
      unless instance_variable_defined?(:@has_rel_repo)
        rel = release_version
        @has_rel_repo = communicate.test(centos_8? ? 'yum repolist' : "yum repolist --enablerepo=C#{rel}-base --enablerepo=C#{rel}-updates")
      end
      @has_rel_repo
    end

    def centos_8?
      release_version && release_version.to_s.start_with?('8')
    end

    def install_kernel_devel(opts=nil, &block)
      if centos_8?
        communicate.sudo('yum update -y kernel', opts, &block)
        communicate.sudo('yum install -y kernel-devel', opts, &block)
        communicate.sudo('shutdown -r now', opts, &block)

        begin
          sleep 10
        end until @vm.communicate.ready?
      else
        rel = has_rel_repo? ? release_version : '*'
        cmd = "yum install -y kernel-devel-`uname -r` --enablerepo=C#{rel}-base --enablerepo=C#{rel}-updates"
        communicate.sudo(cmd, opts, &block)
      end
    end
  end
end

Vagrant.configure("2") do |config|
  config.vagrant.plugins = ['vagrant-vbguest']
  config.vbguest.auto_update = true
  config.vm.box = 'centos/8'
  config.vm.box_url = 'https://cloud.centos.org/centos/8/x86_64/images/CentOS-8-Vagrant-8.1.1911-20200113.3.x86_64.vagrant-virtualbox.box'

  if defined?(MyWorkaroundInstallerUntilPR373IsMerged)
    config.vbguest.installer = MyWorkaroundInstallerUntilPR373IsMerged
  end

  # VM mysql
  config.vm.define "mysql" do |mysql|

    # HOSTNAME
    mysql.vm.hostname = "centos8-mysql"

    # NETWORK
    mysql.vm.network "public_network" ,ip: "192.168.0.134"
    mysql.vm.network "forwarded_port", guest: 3306, host: 3306, adapter: 1 , guest_ip: "192.168.0.134" ,host_ip: "192.168.0.33"

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
      chmod 600 /home/vagrant/security/id_rsa
      chown vagrant:vagrant /home/vagrant/security/id_rsa
      sudo systemctl stop firewalld
      sudo systemctl disable firewalld
      sudo setenforce Permissive
      SHELL

    mysql.vm.provision "shell",inline: <<-SHELL
      sudo yum update -y
      dnf install python3 -y
      SHELL
  end

  #VM wordpress
  config.vm.define "wordpress" do |wordpress|

    # HOSTNAME
    wordpress.vm.hostname = "centos8-wordpress"

    # NETWORK
    wordpress.vm.network "public_network" ,ip: "192.168.0.135"
    wordpress.vm.network "forwarded_port", guest: 80, host: 8080, adapter: 1 , guest_ip: "192.168.0.135" ,host_ip: "192.168.0.33"

    # MOUNTS
    wordpress.vm.synced_folder ".", "/vagrant", disabled: true
    wordpress.vm.synced_folder "./security", "/home/vagrant/security"

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
      chmod 600 /home/vagrant/security/id_rsa
      chown vagrant:vagrant /home/vagrant/security/id_rsa
      sudo systemctl stop firewalld
      sudo systemctl disable firewalld
      sudo setenforce Permissive
      SHELL

    # INSTALL UPDATES AND TOOLS
    wordpress.vm.provision "shell",inline: <<-SHELL
      sudo yum update -y
      dnf install python3 -y
      SHELL

    wordpress.vm.provision "ansible" do |ansible|
      ansible.limit = "all"
      ansible.inventory_path = "provisioning/hosts"
      ansible.playbook = "provisioning/site.yml"

    end

  end

end