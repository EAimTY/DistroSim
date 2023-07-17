#!/bin/bash

GIT_DIR=$(cd $(dirname $0)/..; pwd)
RUN_DIR=${GIT_DIR}/run
mkdir -p ${RUN_DIR}

cd ${RUN_DIR}

killall -u ${USER} cpm5-qdma-demo qemu-system-x86_64

LD_LIBRARY_PATH=${RUN_DIR}/systemc-2.3.3/lib-linux64/ ${GIT_DIR}/pcie/versal/cpm5-qdma-demo unix:${RUN_DIR}/qemu-rport-_machine_peripheral_rp0_rp 10000 &>/dev/null & disown;

QEMU_TARGET="${RUN_DIR}/qemu_install/bin/qemu-system-x86_64"
IMG_SIZE="10G"
VM_MEM_SIZE="16G"
VM_SMP_NUM="8"
RP_PCIE_SLOT_NUM="0"
RP_CHAN_NUM="0"
PCIE_ROOT_SLOT_NUM="1"

UBUNTU_IMG_PATH="${RUN_DIR}/ubuntu-20.04-server-cloudimg-amd64.img"
CLOUD_CONFIG_IMG_PATH="${RUN_DIR}/cloud_init.img"
UBUNTU_KERNEL_PATH="${RUN_DIR}/ubuntu-20.04-server-cloudimg-amd64-vmlinuz-generic"
UBUNTU_INITRD_PATH="${RUN_DIR}/ubuntu-20.04-server-cloudimg-amd64-initrd-generic"
BIOS_PATH="${RUN_DIR}/qemu/pc-bios/bios-256k.bin"

VM_SSH_PORT="47183"

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
    -device virtio-net-pci,netdev=net0 \
    -netdev user,id=net0,hostfwd=tcp::$VM_SSH_PORT-:22 \
    -chardev socket,path=$RUN_DIR/gdb-socket,server=on,wait=off,id=gdb0 -gdb chardev:gdb0 -S \
    -append "root=/dev/sda1 rootwait console=tty1 console=ttyS0 intel_iommu=on nokaslr" \
    &>/dev/null & disown;
