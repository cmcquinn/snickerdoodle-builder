#!/bin/bash

set -e # exit on error
set -x # echo commands

# setup environment
source ${QTDIR}/env.sh

# get the sources
git clone https://github.com/qt/qt5.git ${QTSRCDIR}
cd ${QTSRCDIR}
git checkout ${QTVERSION}
perl init-repository --module-subset=${MODULESUBSET}
mkdir -p ${MKSPECDIR}
cp ${PROJECTDIR}/qt/{qmake.conf,qplatformdefs.h} ${MKSPECDIR}

# convert absolute symlinks to relative symlinks
cd ${WORKDIR}
curl -O https://raw.githubusercontent.com/openembedded/openembedded-core/master/scripts/sysroot-relativelinks.py
chmod +x ./sysroot-relativelinks.py
./sysroot-relativelinks.py ${ROOTFS}

# prepare to build
mkdir -p ${QTBUILDDIR}
cd ${QTBUILDDIR}

# fix libpthread symlink
# mv ${ROOTFS}/usr/lib/arm-linux-gnueabihf/libpthread.so ${ROOTFS}/usr/lib/arm-linux-gnueabihf/libpthread.so.backup
# ln -s ${ROOTFS}/lib/arm-linux-gnueabihf/libpthread.so.0 ${ROOTFS}/usr/lib/arm-linux-gnueabihf/libpthread.so

# run configure
${QTSRCDIR}/configure ${CONFIGUREARGS} ${SKIPMODULES}

# run build
make -j`nproc`

# install
make install