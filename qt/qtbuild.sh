#!/bin/bash

set -e # exit on error
set -x # echo commands

# get path to containing folder
SCRIPTDIR=$( realpath "$0"  ) && dirname "$SCRIPTDIR"

# setup environment
source ${SCRIPTDIR}/env.sh

# get the sources
git clone https://github.com/qt/qt5.git $QTSRCDIR
cd $QTSRCDIR
git checkout $QTVERSION
perl init-repository --module-subset=$MODULESUBSET
mkdir -p $QTSRCDIR/$MKSPECDIR
cp ${PROJECTDIR}/qt/{qmake.conf,qplatformdefs.h} $QTSRCDIR/$MKSPECDIR

# prepare to build
mkdir -p $QTBUILDDIR
cd $QTBUILDDIR

# run configure
$QTSRCDIR/configure $CONFIGUREARGS $SKIPMODULES

# run build
make -j`nproc`

# install
make install