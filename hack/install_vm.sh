#!/bin/bash

set -u

IMAGE_DIR="/var/lib/libvirt/images"

NAME=$1
CPU=2
MEM=2048
DISK=10

# create disk
qemu-img create -f qcow2 ${IMAGE_DIR}/${NAME}.qcow2 ${DISK}G

# create vm
virt-install \
--name=${NAME} \
--vcpus=${CPU} \
--ram=${MEM} \
--disk path=/var/lib/libvirt/images/${NAME}.qcow2 \
--os-type=linux \
--os-variant=rhel7 \
--network=network:kubenet \
--graphics none \
--serial pty \
--console pty \
--location=/var/lib/libvirt/images/CentOS-7-x86_64-DVD-1708.iso \
--initrd-inject ${NAME}.cfg \
--extra-args "inst.ks=file:/${NAME}.cfg console=ttyS0"
