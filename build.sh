#!/bin/bash

set -e # exit on error
set -x # echo commands

docker_image=cmcquinn/snickerdoodle-docker:rootfs
project=snickerdoodle-builder

docker pull ${docker_image}
docker rm ${project} &> /dev/null || true
docker run --privileged --name ${project} -i \
     -v "${PWD}:/${project}" ${docker_image} \
     /bin/bash -c "cd ${project}; ./Recipe"
