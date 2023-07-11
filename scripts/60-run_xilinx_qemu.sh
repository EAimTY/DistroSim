#!/bin/bash

GIT_DIR=$(cd $(dirname $0)/..; pwd)
RUN_DIR=${GIT_DIR}/run
mkdir -p ${RUN_DIR}

cd ${RUN_DIR}

QEMU_TARGET="qemu-system-x86_64 -M q35,kernel-irqchip=split"
IMG_SIZE="10G"
VM_MEM_SIZE="4G"
VM_SMP_NUM="4"
VM_SSH_PORT="22"
VM_SSH_PORT_IN_HOST="2222"
RP_PCIE_SLOT_NUM="0"
RP_CHAN_NUM="0"
PCIE_ROOT_SLOT_NUM="1"
EXIT_ERR_CODE="1"

UBUNTU_IMG_PATH="${RUN_DIR}/ubuntu-22.04-server-cloudimg-amd64.img"
CLOUD_CONFIG_IMG_PATH="${RUN_DIR}/cloud_init.img"
UBUNTU_KERNEL_PATH="${RUN_DIR}/ubuntu-22.04-server-cloudimg-amd64-vmlinuz-generic"
UBUNTU_INITRD_PATH="${RUN_DIR}/ubuntu-22.04-server-cloudimg-amd64-initrd-generic"
BIOS_PATH="${RUN_DIR}/qemu/pc-bios/bios-256k.bin"
TEMP_FILE_PATH="${RUN_DIR}/tmp"

$QEMU_TARGET \
    -m $VM_MEM_SIZE -smp $VM_SMP_NUM -cpu qemu64,rdtscp \
    -serial mon:stdio -display none -no-reboot \
    -drive file=$UBUNTU_IMG_PATH \
    -drive file=$CLOUD_CONFIG_IMG_PATH,format=raw \
    -kernel $UBUNTU_KERNEL_PATH \
    -initrd $UBUNTU_INITRD_PATH \
    -bios $BIOS_PATH \
    -machine-path $TEMP_FILE_PATH \
    -netdev type=user,id=net0,hostfwd=tcp::$VM_SSH_PORT_IN_HOST-:$VM_SSH_PORT \
    -device intel-iommu,intremap=on,device-iotlb=on \
    -device ioh3420,id=rootport1,slot=$PCIE_ROOT_SLOT_NUM \
    -device remote-port-pci-adaptor,bus=rootport1,id=rp0 \
    -device virtio-net-pci,netdev=net0 \
    -device virtio-9p-pci,id=fs0,fsdev=fsdev0,mount_tag=shared \
    -device remote-port-pcie-root-port,id=rprootport,slot=$RP_PCIE_SLOT_NUM,rp-adaptor0=rp,rp-chan0=$RP_CHAN_NUM \
    -fsdev local,security_model=mapped,id=fsdev0,path=$TEMP_FILE_PATH \
    -append "root=/dev/sda1 rootwait console=tty1 console=ttyS0 intel_iommu=on"
