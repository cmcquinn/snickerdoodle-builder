#!/bin/bash

set -x # echo commands

# set work dir to "/work" if it is not already set
WORKDIR="${WORKDIR:-"/work"}"
echo "WORKDIR set to ${WORKDIR}"

# environment variables for the rootfs build system
export PROJECTDIR="${PWD}"
export ROOTFS="${WORKDIR}/multistrap"
export CONFIGDIR="${PROJECTDIR}/configs"
export UTILSDIR="${PROJECTDIR}/utils"
export QTDIR="${PROJECTDIR}/qt"
export PROJECTBASE="$(basename ${PWD})"