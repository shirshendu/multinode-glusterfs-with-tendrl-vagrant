#!/bin/bash -ux

# install gluster 3.12.1 and gstatus on storage nodes
sudo yum install centos-release-gluster -y
sudo yum install glusterfs-server -y

sudo systemctl enable glusterd
sudo systemctl start glusterd
sudo systemctl status glusterd

cd /opt
git clone https://github.com/gluster/gstatus
cd /opt/gstatus
python setup.py install

# specify where bricks to be mounted
mkdir -p /bricks/brick1
if grep -q '^/dev/sdb1' /etc/fstab; then
  exit 0
fi
grep -q '^#/dev/sdb1' /etc/fstab || echo "#/dev/sdb1 	/bricks/brick1				xfs defaults 0 0" >> /etc/fstab
echo "   n 	<— new partition
p 	<— primary partition type
<press enter for all the defaults till partition completed
w	<— writes the partition table\n"
fdisk /dev/sdb
mkfs.xfs /dev/sdb1
parted /dev/sdb print
sed -i '/#/dev/sdb1 	/bricks/brick1				xfs defaults 0 0/c\/dev/sdb1 	/bricks/brick1				xfs defaults 0 0' /etc/fstab
mount -a
