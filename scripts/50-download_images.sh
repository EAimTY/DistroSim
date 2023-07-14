#!/bin/bash

GIT_DIR=$(cd $(dirname $0)/..; pwd)
RUN_DIR=${GIT_DIR}/run
mkdir -p ${RUN_DIR}

cd ${RUN_DIR}

RELEASE_URL="https://cloud-images.ubuntu.com/releases/focal/release"
IMG_SIZE="10G"
UBUNTU_IMG_PATH="${RUN_DIR}/ubuntu-20.04-server-cloudimg-amd64.img"
CLOUD_CONFIG_IMG_PATH="${RUN_DIR}/cloud_init.img"
UBUNTU_KERNEL_PATH="${RUN_DIR}/ubuntu-20.04-server-cloudimg-amd64-vmlinuz-generic"
UBUNTU_INITRD_PATH="${RUN_DIR}/ubuntu-20.04-server-cloudimg-amd64-initrd-generic"
BIOS_PATH="${RUN_DIR}/qemu/pc-bios/bios-256k.bin"

rm -rf ubuntu-20.04-server-cloudimg-amd64.img cloud_init.img ubuntu-20.04-server-cloudimg-amd64-vmlinuz-generic ubuntu-20.04-server-cloudimg-amd64-initrd-generic
wget $RELEASE_URL/ubuntu-20.04-server-cloudimg-amd64.img
qemu-img resize ubuntu-20.04-server-cloudimg-amd64.img $IMG_SIZE
cloud-localds $CLOUD_CONFIG_IMG_PATH $GIT_DIR/scripts/cloud_init.cfg
wget $RELEASE_URL/unpacked/ubuntu-20.04-server-cloudimg-amd64-vmlinuz-generic
wget $RELEASE_URL/unpacked/ubuntu-20.04-server-cloudimg-amd64-initrd-generic
