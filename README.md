## Provision VM for Developer with Wordpress

## Getting Started

    Fork the project and enjoy.
    Atention for pre requisites and License!!!

## Prerequisites

    Virtual Box
    Vagrant

## Authors

    Marcos Silvestrini

## License

    This project is licensed under the MIT License - see the LICENSE.md file for details

## Oficial Doc

    https://www.vagrantup.com/docs/index.html

## Install Vagrant in Rhel Centos 7\8

### Download

    https://releases.hashicorp.com/vagrant/2.2.7/vagrant_2.2.7_x86_64.rpm
    sudo wget https://releases.hashicorp.com/vagrant/2.2.7/vagrant_2.2.7_x86_64.rpm

### Install

    sudo yum localinstall vagrant_2.2.7_x86_64.rpm -y
    vagrant ––version

## Create Box with Apache, Mysql Server and Wordpress

    clone this reposotory
    Generate your ssh pub key and copy to security folder
    cd vagrant-wordpress
    vagrant up

## Vagrantfile

    Configure Network
    Configure Mounts
    Configure ssh
    Configure Firewall (firewalld or iptables)
    Configure Selinux
    Install Updates
