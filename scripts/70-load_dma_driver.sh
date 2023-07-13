#!/bin/bash

GIT_DIR=$(cd $(dirname $0)/..; pwd)
RUN_DIR=${GIT_DIR}/run

DRIVER_DIR="${RUN_DIR}/dma_ip_drivers"

# Use the device connected to the second PCIEHost by default which is the one
# used in the versal-cpie-cpm5 demo.  This might change in case the qdma
# device is wired directly to a remote port.
DEVICE="${DEVICE:-02}"
SYSFS_QMAX=/sys/bus/pci/devices/0000:${DEVICE}:00.0/qdma/qmax
DRVDEV=qdma${DEVICE}000
CHRDEV=/dev/${DRVDEV}-MM-0
DIRMODE=${DEVICE}:0:2
INDIRMODE=${DEVICE}:0:3

DEVICE_ADDR="0x102100000"
DEVICE_ADDR_PLUS_4K="0x102101000"
DATA_SIZE_1K=1024
DATA_SIZE_4K=4096
DATA_SIZE_8K=8192

insmod $DRIVER_DIR/QDMA/linux-kernel/bin/qdma-pf.ko

$DRIVER_DIR/QDMA/linux-kernel/bin/dma-ctl ${DRVDEV} q add idx 0 mode mm dir h2c
$DRIVER_DIR/QDMA/linux-kernel/bin/dma-ctl ${DRVDEV} q add idx 0 mode mm dir c2h
$DRIVER_DIR/QDMA/linux-kernel/bin/dma-ctl ${DRVDEV} q start idx 0 dir c2h
$DRIVER_DIR/QDMA/linux-kernel/bin/dma-ctl ${DRVDEV} q start idx 0 dir h2c
