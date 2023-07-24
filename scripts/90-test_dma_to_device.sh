#!/bin/bash
set -o errexit
set -o nounset

while getopts ":s:c:" opt; do
  case $opt in
    s)
      SIZE=$OPTARG
      ;;
    c)
      COUNT=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

if [ -z "$SIZE" ] || [ -z "$COUNT" ]; then
  echo "Both -s and -c arguments are required."
  exit 1
fi

GIT_DIR=$(cd $(dirname $0)/..; pwd)
RUN_DIR=${GIT_DIR}/run

DRIVER_DIR="${RUN_DIR}/dma_ip_drivers"
DEVICE="${DEVICE:-02}"
DEVICE_ADDR="0x102100000"
DRVDEV=qdma${DEVICE}000
CHRDEV=/dev/${DRVDEV}-MM-0

$DRIVER_DIR/QDMA/linux-kernel/bin/dma-to-device -d $CHRDEV -f /dev/zero -a $DEVICE_ADDR -s $SIZE -c $COUNT -v
