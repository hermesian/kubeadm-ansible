#!/bin/bash
#
# Prepare docker images for offline environment.
# (see https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/#running-kubeadm-without-an-internet-connection)
#

set -e

declare -A imgs

TARGET_DIR=docker_imgs
ARCH=amd64

if [ ! -d "$TARGET_DIR" ]; then
  mkdir docker_imgs
fi

imgs=(
  ["kube-apiserver"]="v1.10.2"
  ["kube-controller-manager"]="v1.10.2"
  ["kube-scheduler"]="v1.10.2"
  ["kube-proxy"]="v1.10.2"
  ["etcd"]="3.1.12"
  ["pause"]="3.1"
  ["k8s-dns-sidecar"]="1.14.8"
  ["k8s-dns-kube-dns"]="1.14.8"
  ["k8s-dns-dnsmasq-nanny"]="1.14.8"
  ["kubernetes-dashboard"]="v1.8.3"
)

# Save docker images
for img in ${!imgs[@]};
do
    VERSION=${imgs[$img]}
    echo "Save "${img}-${ARCH}:${VERSION}
    docker pull gcr.io/google_containers/${img}-${ARCH}:${VERSION}
    docker save gcr.io/google_containers/${img}-${ARCH}:${VERSION} > ${TARGET_DIR}/${img}-${ARCH}_${VERSION}.tar
done

# Pack and remove directory
tar -zcvf ${TARGET_DIR}.tar.gz ${TARGET_DIR}
rm -rf docker_imgs

echo "Done."
