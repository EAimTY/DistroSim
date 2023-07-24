#!/bin/bash
set -o errexit
set -o nounset

GIT_DIR=$(cd $(dirname $0)/..; pwd)
RUN_DIR=${GIT_DIR}/run
mkdir -p ${RUN_DIR}

cd ${RUN_DIR}

if [ "$EUID" -ne 0 ]; then
  echo "Error: This script must be run as root."
  exit 1
fi

mkdir -p /mnt/DistroSim
echo "distrosim /mnt/DistroSim 9p rw,trans=virtio,version=9p2000.L 0 0" >> /etc/fstab

touch /etc/ssh/sshd_config.d/00-root.conf > /etc/ssh/sshd_config.d/00-root.conf
echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config.d/00-root.conf
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config.d/00-root.conf
echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config.d/00-root.conf

passwd -d root

apt-get update -y
apt-get install -y ca-certificates
echo "" > /etc/apt/sources.list
touch /etc/apt/sources.list.d/ubuntu.list > /etc/apt/sources.list.d/ubuntu.list
echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu focal main restricted universe multiverse" >> /etc/apt/sources.list.d/ubuntu.list
echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu focal-updates main restricted universe multiverse" >> /etc/apt/sources.list.d/ubuntu.list
echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu focal-backports main restricted universe multiverse" >> /etc/apt/sources.list.d/ubuntu.list
echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu focal-security main restricted universe multiverse" >> /etc/apt/sources.list.d/ubuntu.list
apt-get update -y
apt-get purge -y snapd
apt-get install -y build-essential git libaio1 libaio-dev kmod linux-headers-generic
apt-get autoremove -y --purge
apt-get autoclean -y
apt-get clean -y

poweroff
