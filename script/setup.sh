#!/bin/sh
. $(dirname $0)/path.sh
test -z ${BUILD_DIR} && exit 127

RELEASE=$(lsb_release -s -c)
if [ -f ${SCRIPT_DIR}/no-${RELEASE} ]; then
  exit 0
fi

CP="scp -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null"

set -x
rm -rf ${BUILD_DIR}/${PACKAGE}
mkdir -p ${BUILD_DIR}
cd ${BUILD_DIR}
mkdir ${PACKAGE}
if [ -f ${SCRIPT_DIR}/no-src ]; then
  if [ -d ${SCRIPT_DIR}/files ]; then
    cp -rp ${SCRIPT_DIR}/files/* ${PACKAGE}
  fi
else
  ${CP} ${DATA_DIR}/src/${PACKAGE}_${VERSION_BASE}.orig.tar.gz .
  tar zxf ${PACKAGE}_${VERSION_BASE}.orig.tar.gz -C ${PACKAGE} --strip-components=1
fi
cd ${PACKAGE}
mkdir -p debian
cp -rp ${SCRIPT_DIR}/debian/* debian/
if [ -d ${SCRIPT_DIR}/debian-${RELEASE} ]; then
  cp -rp ${SCRIPT_DIR}/debian-${RELEASE}/* debian/
fi
sudo apt-get update
sudo apt-get -y upgrade
dpkg-checkbuilddeps 2>&1 | sed 's/dpkg-checkbuilddeps.*dependencies: //' | sudo xargs apt-get -y install
