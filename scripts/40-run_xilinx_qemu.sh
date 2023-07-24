#!/bin/bash
set -o errexit
set -o nounset

ENABLE_GDB_SOCKET=0

while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -gdb)
            ENABLE_GDB_SOCKET=1
            shift
            ;;
        *)
            echo "Unknown option: $key"
            exit 1
            ;;
    esac
done

GIT_DIR=$(cd $(dirname $0)/..; pwd)
RUN_DIR=${GIT_DIR}/run
mkdir -p ${RUN_DIR}

cd ${RUN_DIR}

QEMU_TARGET="${RUN_DIR}/qemu_install/bin/qemu-system-x86_64"
IMG_SIZE="10G"
VM_MEM_SIZE="16G"
VM_SMP_NUM="8"
RP_PCIE_SLOT_NUM="0"
RP_CHAN_NUM="0"
PCIE_ROOT_SLOT_NUM="1"

CLOUDIMG_NAME="focal-server-cloudimg-amd64"
CLOUD_CONFIG_IMG_PATH="${RUN_DIR}/cloud_init.img"
UBUNTU_IMG_PATH="${RUN_DIR}/${CLOUDIMG_NAME}.img"
UBUNTU_KERNEL_PATH="${RUN_DIR}/${CLOUDIMG_NAME}-vmlinuz-generic"
UBUNTU_INITRD_PATH="${RUN_DIR}/${CLOUDIMG_NAME}-initrd-generic"
BIOS_PATH="${RUN_DIR}/qemu/pc-bios/bios-256k.bin"

GDB_SOCKET_PATH="${RUN_DIR}/gdb-socket"
QEMU_LOG_PATH="${RUN_DIR}/qemu.log"
CPM_LOG_PATH="${RUN_DIR}/cpm.log"

VM_SSH_PORT="47183"

GID=$(id -g)

killall -u ${USER} cpm5-qdma-demo qemu-system-x86_64 &>/dev/null || true

echo "" > ${QEMU_LOG_PATH}
echo "" > ${CPM_LOG_PATH}

LD_LIBRARY_PATH=${RUN_DIR}/systemc-2.3.3/lib-linux64/ ${GIT_DIR}/pcie/versal/cpm5-qdma-demo unix:${RUN_DIR}/qemu-rport-_machine_peripheral_rp0_rp 10000 > $CPM_LOG_PATH 2>&1 & disown;

QEMU_COMMAND="${QEMU_TARGET} \
    -M q35,accel=kvm,kernel-irqchip=split --enable-kvm \
    -m ${VM_MEM_SIZE} -smp ${VM_SMP_NUM} -cpu qemu64,rdtscp \
    -nographic \
    -serial file:${QEMU_LOG_PATH} \
    -drive file=${UBUNTU_IMG_PATH} \
    -drive file=${CLOUD_CONFIG_IMG_PATH},format=raw \
    -kernel ${UBUNTU_KERNEL_PATH} \
    -initrd ${UBUNTU_INITRD_PATH} \
    -bios ${BIOS_PATH} \
    -device intel-iommu,intremap=on,device-iotlb=on \
    -device ioh3420,id=rootport1,slot=${PCIE_ROOT_SLOT_NUM} \
    -device remote-port-pci-adaptor,bus=rootport1,id=rp0 \
    -device remote-port-pcie-root-port,id=rprootport,slot=${RP_PCIE_SLOT_NUM},rp-adaptor0=rp,rp-chan0=${RP_CHAN_NUM} \
    -machine-path ${RUN_DIR} \
    -device virtio-net-pci,netdev=net0 \
    -fsdev local,id=distrosim,path=${GIT_DIR},security_model=mapped,uid=${UID},gid=${GID} \
    -device virtio-9p-pci,fsdev=distrosim,mount_tag=distrosim \
    -netdev user,id=net0,hostfwd=tcp::${VM_SSH_PORT}-:22 \
    -append 'root=/dev/sda1 rootwait console=ttyS0 ignore_loglevel intel_iommu=on nokaslr'"

if [ "${ENABLE_GDB_SOCKET}" -eq 1 ]; then
    QEMU_COMMAND+=" -chardev socket,path=${GDB_SOCKET_PATH},server=on,wait=off,id=gdb0 -gdb chardev:gdb0 -S"
fi

eval "${QEMU_COMMAND} &>/dev/null & disown;"
