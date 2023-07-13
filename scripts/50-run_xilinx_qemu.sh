#!/bin/bash

GIT_DIR=$(cd $(dirname $0)/..; pwd)
RUN_DIR=${GIT_DIR}/run
mkdir -p ${RUN_DIR}

cd ${RUN_DIR}

QEMU_TARGET="${RUN_DIR}/qemu_install/bin/qemu-system-x86_64"
IMG_SIZE="10G"
VM_MEM_SIZE="4G"
VM_SMP_NUM="4"
VM_SSH_PORT="22"
VM_SSH_PORT_IN_HOST="2222"
RP_PCIE_SLOT_NUM="0"
RP_CHAN_NUM="0"
PCIE_ROOT_SLOT_NUM="1"
EXIT_ERR_CODE="1"

UBUNTU_IMG_PATH="${RUN_DIR}/ubuntu-20.04-server-cloudimg-amd64.img"
CLOUD_CONFIG_IMG_PATH="${RUN_DIR}/cloud_init.img"
UBUNTU_KERNEL_PATH="${RUN_DIR}/ubuntu-20.04-server-cloudimg-amd64-vmlinuz-generic"
UBUNTU_INITRD_PATH="${RUN_DIR}/ubuntu-20.04-server-cloudimg-amd64-initrd-generic"
BIOS_PATH="${RUN_DIR}/qemu/pc-bios/bios-256k.bin"

$QEMU_TARGET \
    -M q35,accel=kvm,kernel-irqchip=split --enable-kvm \
    -m $VM_MEM_SIZE -smp $VM_SMP_NUM -cpu qemu64,rdtscp \
    -serial mon:stdio -display none -no-reboot \
    -drive file=$UBUNTU_IMG_PATH \
    -drive file=$CLOUD_CONFIG_IMG_PATH,format=raw \
    -kernel $UBUNTU_KERNEL_PATH \
    -initrd $UBUNTU_INITRD_PATH \
    -bios $BIOS_PATH \
    -device intel-iommu,intremap=on,device-iotlb=on \
    -device ioh3420,id=rootport1,slot=$PCIE_ROOT_SLOT_NUM \
    -device remote-port-pci-adaptor,bus=rootport1,id=rp0 \
    -device remote-port-pcie-root-port,id=rprootport,slot=$RP_PCIE_SLOT_NUM,rp-adaptor0=rp,rp-chan0=$RP_CHAN_NUM \
    -machine-path $RUN_DIR \
    -append "root=/dev/sda1 rootwait console=tty1 console=ttyS0 intel_iommu=on"
