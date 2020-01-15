#!/bin/bash

set -x # echo commands

docker_image=cmcquinn/snickerdoodle-docker:rootfs
project=snickerdoodle-builder

echo "TRAVIS_BUILD_DIR: ${TRAVIS_BUILD_DIR}"

docker pull ${docker_image}
docker rm ${project} &> /dev/null || true

export BUILDDIR=$PWD

# setup work directory
if [ -n "${WORKDIR}" ]; then # if WORKDIR env variable is set
     mkdir -p ${WORKDIR} # create WORKDIR if it does not exist
     echo "WORKDIR: ${WORKDIR}"
elif [ -n "${CONTINUOUS_INTEGRATION}" ]; then
     cd ${TRAVIS_BUILD_DIR}/.. # cd to /home/travis/build/cmcquinn
     mkdir -p work
     export WORKDIR=$(realpath work)
else
     export WORKDIR="/work"
     mkdir -p ${WORKDIR}
fi

cd ${BUILDDIR}
docker run --privileged --name ${project} -i \
     -v "${PWD}:/${project}" -v "${WORKDIR}:/work" ${docker_image} \
     /bin/bash -c "cd ${project}; ./Recipe"

git clone https://github.com/cmcquinn/python-utils.git
pip3 install requests
python-utils/bintray.py cmcquinn replicookie-rootfs debian-buster ${WORKDIR}/rootfs.tar.xz