#!/bin/bash

set -e # exit on error
set -x # echo commands

docker_image=cmcquinn/snickerdoodle-docker:rootfs
project=snickerdoodle-builder

echo "TRAVIS_BUILD_DIR: ${TRAVIS_BUILD_DIR}"

docker run --privileged multiarch/qemu-user-static:register
docker pull ${docker_image}
docker rm ${project} &> /dev/null || true
cd ${TRAVIS_BUILD_DIR}/.. # cd to /home/travis/build/cmcquinn
mkdir -p work
mkdir -p cache
workdir=$(realpath work)
cachedir=$(realpath cache)

# if cache exists, restore rootfs from it
if [ -f ${cachedir}/cache.tgz ]; then
     cp ${cachedir}/cache.tgz ${workdir}
     cd ${workdir}
     tar xf cache.tgz
fi

cd ${TRAVIS_BUILD_DIR}
docker run --privileged --name ${project} -i \
     -v "${PWD}:/${project}" -v "${workdir}:/work" ${docker_image} \
     /bin/bash -c "cd ${project}; ./Recipe"
sudo tar -zcf ${cachedir}/cache.tgz ${workdir}/multistrap 
sudo chown $USER:$USER ${cachedir}/cache.tgz # allow access to cache archive by travis user
