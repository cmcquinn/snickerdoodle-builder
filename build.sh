#!/bin/bash

set -e # exit on error
set -x # echo commands

echo ${PWD}
ls -R ${PWD}
docker pull cmcquinn/snickerdoodle-docker:rootfs
docker run cmcquinn/snickerdoodle-docker:rootfs /bin/bash ./Recipe