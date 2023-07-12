#!/bin/bash

GIT_DIR=$(cd $(dirname $0)/..; pwd)
RUN_DIR=${GIT_DIR}/run
mkdir -p ${RUN_DIR}

TEMP_FILE_PATH="${RUN_DIR}/tmp"
mkdir -p $TEMP_FILE_PATH

LD_LIBRARY_PATH=${RUN_DIR}/systemc-2.3.3/lib-linux64/ ./pcie/versal/cpm5-qdma-demo unix:${TEMP_FILE_PATH}/qemu-rport-_machine_peripheral_rp0_rp 10000 &
