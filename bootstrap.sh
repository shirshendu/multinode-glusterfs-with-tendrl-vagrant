#!/bin/bash -ux

### install pre-requisites
sudo yum install git -y
sudo yum install wget -y
sudo yum install python-dns -y
sudo yum install ntp ntpdate -y
sudo chkconfig ntpd on
sudo ntpdate pool.ntp.org
sudo service ntpd start

### install ansible
sudo yum install epel-release -y
sudo yum install ansible -y

### configure disk
# fdisk /dev/sdb
# mkfs.xfs /dev/sdb1
# parted /dev/sdb print

sed '/#===== vagrant peers start =====/,/#===== vagrant peers end =====/d' /etc/hosts

node0='172.28.128.3'
node1='172.28.128.4'
node2='172.28.128.5'
node3='172.28.128.6'
grep -q 'node0.vagrant.test' /etc/hosts || echo "$node0 node0.vagrant.test " >> /etc/hosts
grep -q 'node1.vagrant.test' /etc/hosts || echo "$node1 node1.vagrant.test " >> /etc/hosts
grep -q 'node2.vagrant.test' /etc/hosts || echo "$node2 node2.vagrant.test " >> /etc/hosts
grep -q 'node3.vagrant.test' /etc/hosts || echo "$node3 node3.vagrant.test " >> /etc/hosts
sed 's/^PermitRootLogin no/PermitRootLogin yes/' /etc/ssh/sshd_config > /etc/ssh/sshd_config
sed 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config > /etc/ssh/sshd_config
sed 's/PubkeyAuthentication no/PubkeyAuthentication yes/' /etc/ssh/sshd_config > /etc/ssh/sshd_config
sed 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config > /etc/ssh/sshd_config
service sshd restart

service firewalld stop
systemctl disable firewalld
iptables --flush

# TODO copy it to a temp shared dir?
mkdir /vagrant/tmp
cp .ssh/id_rsa.pub

# done

