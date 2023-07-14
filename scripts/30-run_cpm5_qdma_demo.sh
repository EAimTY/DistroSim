#!/bin/bash

GIT_DIR=$(cd $(dirname $0)/..; pwd)
RUN_DIR=${GIT_DIR}/run
mkdir -p ${RUN_DIR}

killall cpm5-qdma-demo

LD_LIBRARY_PATH=${RUN_DIR}/systemc-2.3.3/lib-linux64/ ${GIT_DIR}/pcie/versal/cpm5-qdma-demo unix:${RUN_DIR}/qemu-rport-_machine_peripheral_rp0_rp 10000 &>/dev/null & disown;
