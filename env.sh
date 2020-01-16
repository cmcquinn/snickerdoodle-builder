#!/bin/bash

# set -x # echo commands

# set work dir to "/work"
WORKDIR="/work"

# environment variables for the rootfs build system
export PROJECTDIR="${PWD}"
export ROOTFS="${WORKDIR}/multistrap"
export CONFIGDIR="${PROJECTDIR}/configs"
export UTILSDIR="${PROJECTDIR}/utils"
export QTDIR="${PROJECTDIR}/qt"
export PROJECTBASE="$(basename ${PWD})"