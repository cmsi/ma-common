#!/bin/sh
. $(dirname $0)/path.sh
test -z ${BUILD_DIR} && exit 127

CP="scp -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null"

set -x
cd ${BUILD_DIR}/${PACKAGE}
ARCH=$(dpkg --print-architecture)
case ${ARCH} in
  amd64)
    if [ ${MA_INCLUDE_SOURCE} = 1 ]; then
      dpkg-buildpackage -us -uc -sa
    else
      dpkg-buildpackage -us -uc
    fi
    ;;
  *)
    dpkg-buildpackage -B -us -uc
    ;;
esac

if [ -f ../${PACKAGE}_${VERSION}_${ARCH}.changes ]; then
  mv -f ../${PACKAGE}_${VERSION}_${ARCH}.changes ../${PACKAGE}_${VERSION}_${ARCH}.changes.orig
  awk '$3!="debug" {print}' ../${PACKAGE}_${VERSION}_${ARCH}.changes.orig > ../${PACKAGE}_${VERSION}_${ARCH}.changes
  FILES=$(awk 'section == "files" { print "../"$5 } $1=="Files:" { section = "files" }' ../${PACKAGE}_${VERSION}_${ARCH}.changes)
  echo "Copying: ../${PACKAGE}_${VERSION}_${ARCH}.changes ${FILES} to ${TARGET_DIR}"
  ${CP} ../${PACKAGE}_${VERSION}_${ARCH}.changes ${FILES} ${TARGET_DIR}
fi
