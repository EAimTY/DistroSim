#!/bin/bash

GIT_DIR=$(cd $(dirname $0)/..; pwd)
RUN_DIR=${GIT_DIR}/run
mkdir -p ${RUN_DIR}

# dependencies: build-essential pkg-config zlib1g-dev libglib2.0-dev libpixman-1-dev libfdt-dev ninja-build libcap-ng-dev libattr1-dev

cd ${RUN_DIR}

git clone https://github.com/Xilinx/qemu.git
cd qemu
mkdir qemu_build qemu_install
cd qemu_build
../configure --target-list=x86_64-softmmu --enable-virtfs --prefix=${RUN_DIR}/qemu_install
make -j
make install
