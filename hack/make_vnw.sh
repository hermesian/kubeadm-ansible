#!/bin/bash

set -ex

# undefine virtual network
# virsh net-undefine kubenet

# create virtual network
cat <<EOF > ./kubenet.xml
<network>
  <name>kubenet</name>
  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>
  <bridge name='virbr1' stp='off' delay='0'/>
  <ip address='192.168.121.1' netmask='255.255.255.0'/>
</network>
EOF

virsh net-define kubenet.xml
virsh net-start kubenet
virsh net-autostart kubenet

# remove virtual network definition
rm -f kubenet.xml
