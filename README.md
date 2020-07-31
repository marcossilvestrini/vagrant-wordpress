# Provision VM for Developer with Wordpress

## Getting Started

    Fork the project and enjoy.
    Atention for pre requisites and License!!!

## Prerequisites

    Virtual Box
    Vagrant
    Ansible
    Python3

## Authors

    Marcos Silvestrini

## License

    This project is licensed under the MIT License - see the LICENSE.md file for details

## References

    https://www.virtualbox.org/wiki/Documentation
    https://www.vagrantup.com/docs/index.html
    https://docs.ansible.com/
    https://www.alura.com.br/formacao-devops

## Install Vagrant in Rhel Centos 7\8

### Download

    https://releases.hashicorp.com/vagrant/2.2.7/vagrant_2.2.7_x86_64.rpm
    sudo wget https://releases.hashicorp.com/vagrant/2.2.7/vagrant_2.2.7_x86_64.rpm

### Install

    sudo yum localinstall vagrant_2.2.7_x86_64.rpm -y
    vagrant ––version

## Project Structure

### Boxes

    Vagrantfile with distribution boxes. If you to change other SO, replace this file in .\Vagrantfile
    Boxes this project: Centos 8 and Oracle Linux 8
    Centos 8 box has a bug in virtualbox guest plugin,however there is a workaround solution applied to Vagrantfile, but this makes the provisioning of machines extremely slow!

### Provisioning

    Ansible structure with inventory, playbooks and roles. This structure is responsible for provisioning the infraestructure of project

### Security

    Important!!!
    This structure is path for generate your ssh key pair.

## Guide of Use

    clone this reposotory
    Generate your ssh pub key and copy to security folder
    Switch your box in box. Default is Oracle Linux
    cd vagrant-wordpress
    vagrant validate
    vagrant up

## Vagrantfile

    Configure Network
    Configure Mounts
    Configure ssh
    Configure Firewall (firewalld or iptables)
    Configure Selinux
    Install Updates
    Install Python 3

## Provisioning (Ansible)

### Role mysql

    Install Mysql and packages
    Create database
    Create User
    Configure Mysql

### Role webserver

    Set default repositories for download packages(Epel\Remi)
    Install Apache,PHP and packages
    Configure Apache and PHP

### Role wordpress

    Install Wordpress
    Configure Wordpress
