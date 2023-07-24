#!/bin/bash
set -o errexit
set -o nounset

GIT_DIR=$(cd $(dirname $0)/..; pwd)
RUN_DIR=${GIT_DIR}/run

DRIVER_DIR="${RUN_DIR}/dma_ip_drivers"
DEVICE="${DEVICE:-02}"
DRVDEV=qdma${DEVICE}000
SYSFS_QMAX=/sys/bus/pci/devices/0000:${DEVICE}:00.0/qdma/qmax

echo 1 > ${SYSFS_QMAX}

$DRIVER_DIR/QDMA/linux-kernel/bin/dma-ctl ${DRVDEV} q add idx 0 mode mm dir h2c
$DRIVER_DIR/QDMA/linux-kernel/bin/dma-ctl ${DRVDEV} q add idx 0 mode mm dir c2h
$DRIVER_DIR/QDMA/linux-kernel/bin/dma-ctl ${DRVDEV} q start idx 0 dir c2h
$DRIVER_DIR/QDMA/linux-kernel/bin/dma-ctl ${DRVDEV} q start idx 0 dir h2c
