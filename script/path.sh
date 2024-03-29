#!/bin/sh

SCRIPT_DIR="$1"
if [ -z ${SCRIPT_DIR} ]; then
  echo "Usage: $0 script_dir"
  exit 127
fi
SCRIPT_DIR=$(cd ${SCRIPT_DIR} && pwd)

PACKAGE=$(echo $(basename ${SCRIPT_DIR}) | sed 's/ma-//g')
VERSION=$(head -1 ${SCRIPT_DIR}/debian/changelog | sed 's/1://g' | cut -d ' ' -f 2 | sed 's/[()]//g')
VERSION_BASE=$(echo ${VERSION} | cut -d '-' -f 1)

echo "PACKAGE: ${PACKAGE}"
echo "VERSION: ${VERSION}"
echo "VERSION_BASE: ${VERSION_BASE}"
echo "SCRIPT_DIR: ${SCRIPT_DIR}"

if [ -x /usr/bin/lsb_release ]; then
  if [ $(lsb_release -s -i) = 'Debian' -o $(lsb_release -s -i) = 'Ubuntu' ]; then
    if [ -z "${DATA_DIR}" ]; then
      DATA_DIR="${HOME}/malive/data"
    fi
    BUILD_DIR="$(pwd)/build"
    TARGET_DIR="${DATA_DIR}/pkg/$(lsb_release -s -c)"
    SOURCE_DIR="${DATA_DIR}/src"
    echo "BUILD_DIR: ${BUILD_DIR}"
    echo "TARGET_DIR: ${TARGET_DIR}"
    echo "SOURCE_DIR: ${SOURCE_DIR}"
  fi
fi
