#!/bin/bash
set -o errexit
set -o nounset
set -o xtrace

GIT_DIR=$(cd $(dirname $0)/..; pwd)
RUN_DIR=${GIT_DIR}/run
mkdir -p ${RUN_DIR}

cd ${RUN_DIR}
wget -q https://www.accellera.org/images/downloads/standards/systemc/systemc-2.3.3.tar.gz && tar xzf systemc-2.3.3.tar.gz
cd systemc-2.3.3
./configure --prefix=${RUN_DIR}/systemc-2.3.3
make -j
make install
