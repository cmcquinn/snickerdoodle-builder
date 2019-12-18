#!/bin/bash

set -e # exit on error
set -x # echo commands

docker_image=cmcquinn/snickerdoodle-docker:rootfs
project=snickerdoodle-builder

echo "TRAVIS_BUILD_DIR: ${TRAVIS_BUILD_DIR}"

docker run --privileged multiarch/qemu-user-static:register
docker pull ${docker_image}
docker rm ${project} &> /dev/null || true
cd .. # cd to /home/travis/build/cmcquinn
mkdir work
workdir=$(realpath work)
cd $OLDPWD # cd to previous working dir
docker run --privileged --name ${project} -i \
     -v "${PWD}:/${project}" -v "${workdir}:/work" ${docker_image} \
     /bin/bash -c "cd ${project}; ./Recipe"
