#!/bin/bash

set -e

vms=("k8s-master" "k8s-minion1" "k8s-minion2")

for domain in ${vms[@]}
do
    echo "Deleting ${domain}."
    virsh destroy ${domain}
    virsh undefine ${domain}
    rm -rf /var/lib/libvirt/images/${domain}.qcow2
done

virsh list --all

echo "Done."
