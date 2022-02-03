#!/bin/sh
. $(dirname $0)/path.sh
set -x

mkdir -p ${BUILD_DIR}
cd $(dirname ${BUILD_DIR})
scp -p -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null ${DATA_DIR}/src/${PACKAGE}_${VERSION_BASE}.orig.tar.gz .
if [ -f ${PACKAGE}_${VERSION_BASE}.orig.tar.gz ]; then
  tar zxf ${PACKAGE}_${VERSION_BASE}.orig.tar.gz -C build --strip-components=1
  cd ${BUILD_DIR}
  mkdir -p debian
  cp -rp ${SCRIPT_DIR}/debian/* debian/
  if [ -d ${SCRIPT_DIR}/debian-$(lsb_release -s -c) ]; then
    cp -rp ${SCRIPT_DIR}/debian-$(lsb_release -s -c)/* debian/
  fi
  apt-get update
  apt-get -y upgrade
  dpkg-checkbuilddeps 2>&1 | sed 's/dpkg-checkbuilddeps.*dependencies: //' | xargs apt-get -y install
fi
