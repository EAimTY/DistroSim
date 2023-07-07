#!/bin/bash

RUN_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/../run

mkdir -p ${RUN_DIR}
cd ${RUN_DIR/..}
git submodule update --init libsystemctlm-soc
git submodule update --init pcie-model
cat <<EOF > .config.mk
SYSTEMC = ${RUN_DIR}/systemc-2.3.3
EOF
cat .config.mk
make pcie/versal/cpm5-qdma-demo pcie/versal/cpm4-qdma-demo
