#!/bin/bash

set -x # echo commands

# environment variables for the Qt build
export QTSRCDIR="/tmp/qt5"
export QTBUILDDIR="/tmp/qtbuild"
export MKSPECDIR="${QTSRCDIR}/qtbase/mkspecs/devices/linux-arm-xilinx-zynq-g++"
export QTVERSION="v5.14.0"

# options for the configure script
export CONFIGUREARGS="-confirm-license \
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
	CROSS_COMPILE=arm-linux-gnueabihf- \
    -sysroot ${ROOTFS}"

# subset of modules to pull down from git
export MODULESUBSET="essential,-qtwebengine,qtdeclarative,qtquickcontrols,qtquickcontrols2"

# modules not to build
export SKIPMODULES="-skip qt3d \
	-skip qtcanvas3d \
	-skip qtconnectivity \
	-skip qtfeedback \
	-skip qtgraphicaleffects \
	-skip qtlocation \
	-skip qtpurchasing \
	-skip qtqa \
	-skip qtpim \
	-skip qtscript \
	-skip qtsensors \
	-skip qtserialport \
	-skip qtsystems \
	-skip qtwayland \
	-skip qtwebchannel \
	-skip qtwebengine \
	-skip qtwebsockets \
	-skip qtxmlpatterns"