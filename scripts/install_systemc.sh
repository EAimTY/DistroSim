#!/bin/bash

RUN_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/../run

mkdir -p ${RUN_DIR}
cd ${RUN_DIR}
wget -q https://www.accellera.org/images/downloads/standards/systemc/systemc-2.3.3.tar.gz && tar xzf systemc-2.3.3.tar.gz
cd systemc-2.3.3
./configure --prefix=${RUN_DIR}/systemc-2.3.3
make -j
make install
