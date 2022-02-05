#!/bin/sh
. $(dirname $0)/path.sh
set -x

mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}
mkdir -p debian
cp -rp ${SCRIPT_DIR}/debian/* debian/
if [ -d ${SCRIPT_DIR}/debian-$(lsb_release -s -c) ]; then
  cp -rp ${SCRIPT_DIR}/debian-$(lsb_release -s -c)/* debian/
fi
if [ -d ${SCRIPT_DIR}/files ]; then
  cp -rp ${SCRIPT_DIR}/files/* .
fi
apt-get update
apt-get -y upgrade
dpkg-checkbuilddeps 2>&1 | sed 's/dpkg-checkbuilddeps.*dependencies: //' | xargs apt-get -y install
