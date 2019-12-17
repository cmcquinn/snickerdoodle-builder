#!/bin/bash

set -x # echo commands

# environment variables for the rootfs build system
export PROJECTDIR="${PWD}"
export ROOTFS="/tmp/multistrap"
export CONFIGDIR="${PROJECTDIR}/configs"
export UTILSDIR="${PROJECTDIR}/utils"
export QTDIR="${PROJECTDIR}/qt"
export PROJECTBASE="$(basename ${PWD})"