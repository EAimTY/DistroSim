#!/bin/bash
set -o errexit
set -o nounset

GIT_DIR=$(cd $(dirname $0)/..; pwd)
RUN_DIR=${GIT_DIR}/run

DRIVER_DIR="${RUN_DIR}/dma_ip_drivers"
DEVICE="${DEVICE:-02}"

insmod $DRIVER_DIR/QDMA/linux-kernel/bin/qdma-pf.ko
