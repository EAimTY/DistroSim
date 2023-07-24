#!/bin/bash
set -o errexit
set -o nounset
set -o xtrace

GIT_DIR=$(cd $(dirname $0)/..; pwd)
RUN_DIR=${GIT_DIR}/run
mkdir -p ${RUN_DIR}

cd ${RUN_DIR}

IMG_SIZE="10G"
RELEASE_URL="https://mirrors.tuna.tsinghua.edu.cn/ubuntu-cloud-images/focal/current"
CLOUDIMG_NAME="focal-server-cloudimg-amd64"
CLOUD_CONFIG_IMG_PATH="${RUN_DIR}/cloud_init.img"
UBUNTU_IMG_PATH="${RUN_DIR}/${CLOUDIMG_NAME}.img"
UBUNTU_KERNEL_PATH="${RUN_DIR}/${CLOUDIMG_NAME}-vmlinuz-generic"
UBUNTU_INITRD_PATH="${RUN_DIR}/${CLOUDIMG_NAME}-initrd-generic"

rm -rf cloud_init.img ${CLOUDIMG_NAME}.img ${CLOUDIMG_NAME}-vmlinuz-generic ${CLOUDIMG_NAME}-initrd-generic
wget ${RELEASE_URL}/${CLOUDIMG_NAME}.img
qemu-img resize ${CLOUDIMG_NAME}.img $IMG_SIZE
cloud-localds $CLOUD_CONFIG_IMG_PATH $GIT_DIR/scripts/cloud_init.cfg
wget $RELEASE_URL/unpacked/${CLOUDIMG_NAME}-vmlinuz-generic
wget $RELEASE_URL/unpacked/${CLOUDIMG_NAME}-initrd-generic
