#!/bin/bash

set -e # exit on error
set -x # echo commands

QTSRCDIR="/tmp/qt5"
QTBUILDDIR="/tmp/qtbuild"
MKSPECDIR="qtbase/mkspecs/devices/linux-arm-xilinx-zynq-g++"
QTVERSION="v5.14.0"

# subset of modules to pull down from git
MODULESUBSET="essential,-qtwebengine,qtdeclarative,qtquickcontrols,qtquickcontrols2,qtquick1"

# modules not to build
SKIPMODULES="qt3d \
	qtcanvas3d \
	qtconnectivity \
	qtenginio \
	qtfeedback \
	qtgraphicaleffects \
	qtlocation \
	qtpim \
	qtscript \
	qtsensors \
	qtserialport \
	qtsystems \
	qtwayland \
	qtwebchannel \
	qtwebengine \
	qtwebsockets \
	qtxmlpatterns"
CONFIGUREARGS="-confirm-license \
	-opensource \
	-release \
	-xcb \
	-nomake \
	tests \
	-nomake \
	examples \
	-optimized-qmake \
	-device \
	linux-arm-xilinx-zynq-g++ \
	-device-option \
	CROSS_COMPILE=arm-linux-gnueabi- \
    -sysroot ${ROOTFS}"

# get the sources
git clone https://github.com/qt/qt5.git $QTSRCDIR
mkdir -p $QTSRCDIR/$MKSPECDIR
cp ${PROJECTDIR}/qt/{qmake.conf,qplatformdefs.h} $QTSRCDIR/$MKSPECDIR
cd $QTSRCDIR
git checkout $QTVERSION
perl init-repository --module-subset=$MODULESUBSET

# prepare to build
mkdir -p $QTBUILDDIR
cd $QTBUILDDIR

# run configure
$QTSRCDIR/configure $CONFIGUREARGS -skip $SKIPMODULES

# run build
make -j`nproc`

# install
make install