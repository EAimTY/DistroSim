#!/bin/bash

RUN_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/../run

mkdir -p $RUN_DIR
LD_LIBRARY_PATH=${RUN_DIR}/systemc-2.3.3/lib-linux64/ ./pcie/versal/cpm5-qdma-demo unix:${RUN_DIR}/qemu-rport-_machine_peripheral_rp0_rp 10000 &
