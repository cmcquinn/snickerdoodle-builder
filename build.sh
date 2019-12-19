#!/bin/bash

set -x # echo commands

docker_image=cmcquinn/snickerdoodle-docker:rootfs
project=snickerdoodle-builder

echo "TRAVIS_BUILD_DIR: ${TRAVIS_BUILD_DIR}"

docker run --privileged multiarch/qemu-user-static:register
docker pull ${docker_image}
docker rm ${project} &> /dev/null || true
cd ${TRAVIS_BUILD_DIR}/.. # cd to /home/travis/build/cmcquinn
mkdir -p work
workdir=$(realpath work)
cd ${TRAVIS_BUILD_DIR}
docker run --privileged --name ${project} -i \
     -v "${PWD}:/${project}" -v "${workdir}:/work" ${docker_image} \
     /bin/bash -c "cd ${project}; ./Recipe"

git clone https://github.com/cmcquinn/python-utils.git
pip3 install requests
python-utils/bintray.py cmcquinn replicookie-rootfs debian-buster ${workdir}/rootfs.tar.xz