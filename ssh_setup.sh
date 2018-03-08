#!/bin/bash -ux

cat /dev/zero | ssh-keygen -q -N ""
ssh-copy-id -o "StrictHostKeyChecking no" root@node0.vagrant.test
/usr/bin/expect "password"
/usr/bin/send "vagrant\r"

ssh-copy-id -o "StrictHostKeyChecking no" root@node1.vagrant.test
ssh-copy-id -o "StrictHostKeyChecking no" root@node2.vagrant.test
ssh-copy-id -o "StrictHostKeyChecking no" root@node3.vagrant.test
