#!/bin/bash

GIT_DIR=$(cd $(dirname $0)/..; pwd)
RUN_DIR=${GIT_DIR}/run
mkdir -p ${RUN_DIR}

# dependencies: build-essential pkg-config zlib1g-dev libglib2.0-dev libpixman-1-dev libfdt-dev ninja-build libcap-ng-dev libattr1-dev

cd ${RUN_DIR}

git clone https://github.com/Xilinx/qemu.git
cd qemu
mkdir qemu_build
cd qemu_build
../configure --target-list=x86_64-softmmu --enable-virtfs
make -j
make install

cd ${RUN_DIR}

RELEASE_URL="https://cloud-images.ubuntu.com/releases/jammy/release"
IMG_SIZE="10G"
UBUNTU_IMG_PATH="${RUN_DIR}/ubuntu-22.04-server-cloudimg-amd64.img"
CLOUD_CONFIG_IMG_PATH="${RUN_DIR}/cloud_init.img"
UBUNTU_KERNEL_PATH="${RUN_DIR}/ubuntu-22.04-server-cloudimg-amd64-vmlinuz-generic"
UBUNTU_INITRD_PATH="${RUN_DIR}/ubuntu-22.04-server-cloudimg-amd64-initrd-generic"
BIOS_PATH="${RUN_DIR}/qemu/pc-bios/bios-256k.bin"

rm -rf ubuntu-22.04-server-cloudimg-amd64.img cloud_init.img ubuntu-22.04-server-cloudimg-amd64-vmlinuz-generic ubuntu-22.04-server-cloudimg-amd64-initrd-generic
wget $RELEASE_URL/ubuntu-22.04-server-cloudimg-amd64.img
qemu-img resize ubuntu-22.04-server-cloudimg-amd64.img $IMG_SIZE
cloud-localds $CLOUD_CONFIG_IMG_PATH $GIT_DIR/scripts/cloud_init.cfg
wget $RELEASE_URL/unpacked/ubuntu-22.04-server-cloudimg-amd64-vmlinuz-generic
wget $RELEASE_URL/unpacked/ubuntu-22.04-server-cloudimg-amd64-initrd-generic
