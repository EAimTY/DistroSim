#!/bin/bash

GIT_DIR=$(cd $(dirname $0)/..; pwd)
RUN_DIR=${GIT_DIR}/run
mkdir -p ${RUN_DIR}

# dependencies: git make gcc libaio1 libaio-dev kmod linux-headers-generic

cd ${RUN_DIR}

TEMP_FILE_PATH="${RUN_DIR}/tmp"

git clone https://github.com/Xilinx/dma_ip_drivers.git
cd dma_ip_drivers/QDMA/linux-kernel
make TANDEM_BOOT_SUPPORTED=1 KDIR=/usr/src/linux-headers-$(uname -r)

mkdir -p $TEMP_FILE_PATH
rm -rf $TEMP_FILE_PATH/dma_ip_drivers
cp -r $RUN_DIR/dma_ip_drivers $TEMP_FILE_PATH
